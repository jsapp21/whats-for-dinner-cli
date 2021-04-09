# What's for Dinner CLI Application

This application will auto generate a recipe based on a category selection (ex. Chicken, Veggie, Dessert) & gives the user step-by-step instructions. The user can also save a recipe as their favorite.

## Before contributing 

1. From the Github page please Fork & Clone the SSH to your local repo.
2. Open cloned file folder in terminal

## File structure

1. apps/Models - domain models files
2. bin - run.rb file to run the application
3. config - environment setup
4. db - database for application, schema & seeds file
5. lib - cli.rb (command line prompts)
6. Rakefile
7. Gemfile
8. README.md

## How to run the application

Inside your terminal type (in order):

* bundle install - This will make sure you have all the gems needed to run the program
* rake db:migration - this sets up your database tables
* rake db:seed - this seeds your database
* ruby bin/run.rb - This will prompt the application to start in your terminal

## Domain modeling: (many to many relationship)

Domain modeling: (many to many relationship)

User --< Favorite >---Recipe

User 
* has many favorites
* has many recipes through favorites 

Favorite
* belongs to a user 
* belongs to a recipe

Recipe 
* has many favorites 
* has many users through favorites

## How does the CLI work
The user can first login or create a new user.
The app then ask what category of food would like they to cook tonight.
Then a random recipe is displayed.
The user can then make a selection (save, search, view favorites, log out)
- save will save the recipe as a favorite
- search will bring them back to the home page
- view will take them to their favorite recipes
- log out will exit the application

Inside View Favorites
- user can view a favorite recipe
- user can write a note about their favorite recipe
- user can delete the favorite recipe

---

Created by: James Sapp and Aaron Dougher

