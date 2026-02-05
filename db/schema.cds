namespace espressotutorials.buch.reciperater;

using {
    User,
    managed,
    cuid
} from '@sap/cds/common';

entity Recipes : cuid, managed {
    @mandatory name    : String;
    ingredients        : array of String;
    cookwares          : array of String;
    instruction        : String;
    servingCount       : Integer;
    cookingTimeMinutes : Integer;
    reviews            : Composition of many Reviews on reviews.
    recipe = $self;
}

entity Reviews : cuid, managed {
    @mandatory recipe    : Association to Recipes;
    @mandatory title     : String(100);
    @mandatory text      : String(1000);
    @assert.range rating : Rating;
    likes                : Composition of many Likes on likes.
    review = $self;
}

type Rating : Integer enum {
    ![very satisfied]    = 5;
    satisfied            = 4;
    fair                 = 3;
    dissatisfied         = 2;
    ![very dissatisfied] = 1;
}

entity Likes {
    key review : Association to Reviews;
    key user   : User;
}