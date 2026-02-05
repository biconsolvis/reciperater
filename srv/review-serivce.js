const cds = require("@sap/cds")

module.exports = cds.service.impl(function () {
    const { Reviews, Likes } = this.entities("espressotutorials.buch.reciperater")

    this.on("like", "Reviews", async (req) => {
        const review = await SELECT.one(Reviews).where({ ID: req.params[0] })

        if (!review) return req.reject(404, "Dieses Review existiert nicht.")
        INSERT.into(Likes).entries({ review_ID: review.ID, user: req.user.id }).catch(() => req.reject(400, "Sie haben dieses Review bereits geliked."))
    })

    this.on("unlike", "Reviews", async (req) => {
        const review = req.params[0]

        return await DELETE.from(Likes).where({ review_ID: review, user: req.user.id })
    })
    this.after(["CREATE", "UPDATE", "DELETE"], "Reviews", async (data) => {
        const { recipe_ID } = data
        const { averageRating } = await SELECT.one(["round(avg(rating),2) as averageRating"]).from(Reviews).where({ recipe_ID })

        console.log("Ereignis:", "ReviewService/reviewed", { recipe_ID, averageRating })
        await this.emit("reviewed", { recipe_ID, averageRating })
    })

    this.on("reviewed", (msg, next) => {
        console.log(
            `Reaktion: Neue Bewertung für ID ${msg.data.recipe_ID}. Neue Durchschnittsbewertung ${msg.data.averageRating}`,
        )
        return next()
    })

})

