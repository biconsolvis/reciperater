using {espressotutorials.buch.reciperater as buch} from '../db/schema';

service AdminService @(requires : 'admin')
{
entity Recipes as projection on buch.Recipes;
entity Reviews as projection on buch.Reviews;
entity Likes as projection on buch.Likes;
}