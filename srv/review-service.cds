using {espressotutorials.buch.reciperater as buch} from '../db/schema';

@requires: 'authenticated-user'
service ReviewService {

    @restrict: [
        {grant: [
            'READ',
            'CREATE',
            'like'
        ]},
        {
            grant: 'UPDATE',
            to   : 'authenticated-user',
            where: 'reviewer=$user'
        },
        {
            grant: 'unlike',
            to   : 'authenticated-user',
            where: 'user=$user'
        }
    ]
    entity Reviews as
        select from buch.Reviews {
            *,
            createdBy as reviewer
        }
        excluding {
            createdBy,
            createdAt,
            likes,
            modifiedAt,
            modifiedBy
        }
        actions {
            action like();
            action unlike();
        }

    @topic: 'ReviewService'
    event reviewed : {
        id            : type of Recipes : ID;
        averageRating : Decimal(1, 2)
    }

    @restrict: [{
        grant: 'READ',
        to   : 'authenticated-user',
        where: 'user=$user'
    }]
    entity Likes   as projection on buch.Likes;

    @readonly
    entity Recipes as
        projection on buch.Recipes
        excluding {
            createdAt,
            createdBy,
            modifiedAt,
            modifiedBy
        }

}
