using { espressotutorials.buch.reciperater as buch } from '../db/schema';
@(requires: 'any')
service PubilcService @(path : '/browse') {

@readonly
entity Recipes as select from buch.Recipes {
    ID,
    name,
    instruction,
    cookwares,
    ingredients,
    servingCount,
    cookingTimeMinutes,
    reviews
};

@readonly
entity Reviews as select from buch.Reviews {
    *,
    createdBy as reviewer,
    @Core.Computed
    count(
        likes.user
    )   as numberOfLikes : Integer
}
excluding{
    createdBy,
    createdAt,
    modifiedAt,
    modifiedBy,
    likes
}    
group by
ID,recipe,text,title,createdBy,rating;
}