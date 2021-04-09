require 'pry'
class CLI

    def run
        logo 
        sign_in_or_create_login 
        Rails.application.load_seed
    end

    def logo
        puts "
        ╦ ╦┌─┐┬  ┌─┐┌─┐┌┬┐┌─┐  ┌┬┐┌─┐  ╦ ╦┬ ┬┌─┐┌┬┐┌─┐  ┌─┐┌─┐┬─┐  ╔╦╗┬┌┐┌┌┐┌┌─┐┬─┐┌─┐
        ║║║├┤ │  │  │ ││││├┤    │ │ │  ║║║├─┤├─┤ │ └─┐  ├┤ │ │├┬┘   ║║│││││││├┤ ├┬┘ ┌┘
        ╚╩╝└─┘┴─┘└─┘└─┘┴ ┴└─┘   ┴ └─┘  ╚╩╝┴ ┴┴ ┴ ┴ └─┘  └  └─┘┴└─  ═╩╝┴┘└┘┘└┘└─┘┴└─ o 
        ".colorize(:green)
        divider
    end

    def sign_in_or_create_login
        prompt = TTY::Prompt.new
        options = ["Login", "Create a new user"]
        prompt.select("Select an option:", options) 

        login  
    end

    def login
        puts "Enter your username:" 
        
        user_name = gets.chomp 
        @user = User.create_user(user_name)
        sleep 2
        home 
    end

    def home
        clear_terminal
        logo 

        puts "Welcome #{@user.name}, what do you feel like cooking tonight?"
        puts "\n"
        prompt = TTY::Prompt.new
        display_categories = Recipe.all_categories
        choice = prompt.select("Select a category:", display_categories)

        recipe_choice = Recipe.all.where(category: choice)
        first_choice = recipe_choice.sample

        display_recipe(first_choice) 
    end

    def display_recipe(choice)
        clear_terminal
        logo 

        puts "Ta Da! Let's cook this yummie #{choice.category} meal:"
        puts "\n"

        table = TTY::Table.new(["Name: #{choice.name}  --  Region: #{choice.region}  --  Time: #{choice.time} minutes"], [["Ingredients: #{choice.ingredient_list}"], ["Instructions: #{choice.instruction}"]])
        puts table.render(:unicode, padding: [1,1,1,1], width: 90, resize: true, multiline: true)
        puts "\n"

        prompt = TTY::Prompt.new
        display_categories = ["Search again?", "Add to Favorite", "View Favorites", "Log Off"]
        second_choice = prompt.select("Select one:", display_categories)

        selection(second_choice, choice)
    end

    def selection(second_choice, recipe)
        if second_choice == "Search again?"
            add_more_seeds
            home 
        elsif second_choice == "Add to Favorite"
            @user.create_favorite(recipe)
            sleep 1
            display_recipe(recipe)
        elsif second_choice == "View Favorites"
            if display_favorites.any? == false  
                puts "Sorry, you have no favorites saved."
                sleep 1
                display_recipe(recipe)
            else
                view_favorites
            end
        else second_choice == "Log Off"
            clear_terminal
            log_off
        end
    end

    def display_favorites
        @user.reload 
        @user.recipes.map do |recipe|
            recipe.name
        end
    end

    def view_favorites
        clear_terminal
        logo 
        puts "#{@user.name} favorties:" 

        prompt = TTY::Prompt.new
        fav_choice = prompt.select("Select a favorite:", display_favorites)

        fav_recipe = @user.recipes.where(name: fav_choice)
        sent_recipe = fav_recipe.first 

        display_fav_recipe(sent_recipe)
    end

    def display_fav_recipe(sent_recipe)
        clear_terminal
        logo 

        puts "Your favorite #{sent_recipe.category} recipe:"
        puts "\n"

        table = TTY::Table.new(["Name: #{sent_recipe.name}  --  Region: #{sent_recipe.region}  --  Time: #{sent_recipe.time} minutes"], [["Ingredients: #{sent_recipe.ingredient_list}"], ["Instructions: #{sent_recipe.instruction}"]])
        puts table.render(:unicode, padding: [1,1,1,1], width: 90, resize: true, multiline: true)
        puts "\n"
        
        this_favorite = @user.favorites.find_by(recipe_id: sent_recipe.id)
        if this_favorite.user_note != nil
            puts "Recipe Note: #{this_favorite.user_note}"
            puts "\n"
        end

        prompt = TTY::Prompt.new
        display_categories = ["Add Note", "Delete from Favorite", "View Favorites", "Search Recipes", "Log Off"]
        thrid_choice = prompt.select("Select one:", display_categories)

        fav_selection(thrid_choice, sent_recipe)
    end

    def fav_selection(thrid_choice, sent_recipe)
        if thrid_choice == "Add Note"
            add_note(sent_recipe)
        elsif thrid_choice == "Delete from Favorite"
            @user.delete_favorite(sent_recipe) 
            puts "Recipe has been deleted.".colorize(:green)
            sleep 1
            home 
        elsif thrid_choice == "View Favorites"
            view_favorites
        elsif thrid_choice == "Search Recipes"
            home
        else thrid_choice == "Log Off"
            clear_terminal
            log_off
        end
    end

    def add_note(sent_recipe)
        puts "Enter a note for this recipe:"
        new_note = gets.chomp
        
        this_favorite = @user.favorites.find_by(recipe_id: sent_recipe.id)
        this_favorite.add_note_to_recipe(new_note)
        
        display_fav_recipe(sent_recipe)
    end
    
    def log_off
        puts "Goodbye #{@user.name}! Happy cooking!"
        chef_kiss
        clear_terminal
    end 

    def clear_terminal
        system "clear"
    end

    def divider
        puts "🌮 ** 🥗 ** 🍕 ** 🌭 ** 🍜 ** " * 3
        puts "\n"
    end

    def chef_kiss
        puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@".colorize(:green)
        puts "@@@@@@@@@@@@@@@@@@,*,,,.......................,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@".colorize(:green)
        puts "@@@@@@@,,,,,..........,,,.......        .......,,,,.....,,*,@@@@@@@@@@@@@@@@@@@@".colorize(:green)
        sleep 0.2
        puts "@@@*,,,.............,,,,,,,,.......   .....,,,,,,,,,,.......,***@@@@@@@@@@@@@@@@".colorize(:green)
        puts "@,,,,.............,,,,,,,,,,,............,,,***,,,,,,.........,,***@@@@@@@@@@@@@".colorize(:green)
        puts "@,,,,,,,,,,......,,,,,,,,***,,..........,,,*//*,,,,,,,........,,,****@@@@@@@@@@@".colorize(:green)
        sleep 0.2
        puts "@/,,,,,****,,,,,,,,,,,,,,*//*,,,,,,,,,,,,,**/*,,,,,,,,,,,,,,,,********@@@@@@@@@@".colorize(:green)
        puts "@@@@,,,,***//**********////////**********//////*****,,,,,***//*********@@@@@@@@@".colorize(:green)
        puts "@@@@@@@******////****,,,,,,,,,.................,,,,**///*//*********%@@@@@@@@@@@".colorize(:green)
        sleep 0.2
        puts "@@@@@@@@@@@/***,,,,,,,,,,,.......................,,,,,,,**/**@@@@@@@@@@@@@@@@@@@".colorize(:green)
        puts "@@@@@@@@@@@*,,,,,,,,,,,,........           .......,,,,,,,,**@@@@@,%###%%@@@@@@@@".colorize(:green)
        puts "@@@@@@@@@@**,,,,,,,,,,,,,,,**///******///**,.......,,,,,,,,*@@@@#######%%%/%#&@@".colorize(:green)
        sleep 0.2
        puts "@@@@@@@@@@*,,,,//*,,....                     .....,,**/*,,,*,@@@/%###########%%,".colorize(:green)
        puts "@@@@@@@@@@%(/**,,.......                      ........,,*//*@@@@@%%%%%%%%%%%%%%(".colorize(:green)
        puts "@@@@@@@@@%(**,,,................ ............... &&&&&&,.,*/(@@@@@&%%%%%%%%%%&@@".colorize(:green)
        sleep 0.2
        puts "@@@@@@@@@(/**,,..............&&&&&&,....................,***/*@@@@@&&&&(#@@@@@@@".colorize(:green)
        puts "@@@@@@@@(/**,,,,........&&%%(................. ,,%&&%%,,,,***(@@@@@@@@@@@@@@@@@@".colorize(:green)
        puts "@@@@@@@@(/***,,,,.....&%...,%/ .  /&&&........%####...,,,,***/,@@@@@@@@@@@@@@@@@".colorize(:green)
        sleep 0.2
        puts "@@@@@@@@//***,,,,,.........%#########................,,,,*#@*//@@@@@@@@@@@@@@@@@".colorize(:green)
        puts "@@@@@@@@//****,,,,,,................................,,,#@@#**/,@@@@@@@@@@@@@@@@@".colorize(:green)
        puts "@@@@@@@@(/*****,,,,,,,,,......................,#@@@@/,,***/*******//@@@@@@@@@@@@".colorize(:green)
        sleep 0.2
        puts "@@@@@@@@@//*************,,,,&........(&@@@,..,,,,,,,*****,**///*,,,**//*@@@@@@@@".colorize(:green)
        puts "@@@@@@@@@///***************,(@@@%,.,,,,,,,,,,,,,(&***/***,,,,,,,,**/*,**/**@@@@@".colorize(:green)
        puts "@@@@@@@@@@#//***************,,,,,,,,,,,,,,,,,,%%**////**////**,,,,,,,**,,,,*,*,@".colorize(:green)
        sleep 0.2
        puts "@@@@@@@@@@@@(/**************,,,,,,,,,,,,,,,,,,,,&%*//////(*@@@@*,,.....,,,,,,,,*".colorize(:green)
        puts "@@@@@@@@@@@@@@(/************,,,,,,,,,,,,,,,,,,*&&,*/**,**(@@@@@@@*,..........,,*".colorize(:green)
        puts "@@@@@@@@@@@@@@@@(//*********,,,,,,,,,,,,,,,********//**,,**/@@@@@@,,.........,,*".colorize(:green)
        sleep 0.2
        puts "@@@@@@@@@@@@@@@@@@@(///*************************//(*@@/*,,,,*/////,,.........,,/".colorize(:green)
        puts "@@@@@@@@@@@@@@@@@@@@@@@*(///**************////(%@@@@@@@@**,,,,,**,,.........,,*,".colorize(:green)
        puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,/####(*,@@@@@@@@@@@@@@@@@@**,,............,,,,/@".colorize(:green)
        sleep 0.2
        puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@**,,,,,,.,,,,,,,*(@@".colorize(:green)
        puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,/**,,,,,**/(@@@@@".colorize(:green)
        sleep 5
    end

    def add_more_seeds
        
        api_key = ENV["API_KEY"]
        api_url = "https://www.themealdb.com/api/json/v2/#{api_key}/"
        
        find_ten_random = api_url + "randomselection.php"
    
        3.times do
        recipe_data = RestClient.get(find_ten_random)
        parsed_recipe = JSON.parse(recipe_data.body)
        parsed_recipe.map do |meal_hash|
           
            i = 0
            while i < 10 do
            meal = meal_hash[1][i]
            meal_name = meal["strMeal"]
            meal_category = meal["strCategory"]
            meal_instructions = meal["strInstructions"]
            meal_area = meal["strArea"]

            one_i = meal["strMeasure1"] + ' ' + meal["strIngredient1"] + ', '
            two_i = meal["strMeasure2"] + ' ' + meal["strIngredient2"] + ', '
            three_i = meal["strMeasure3"] + ' ' + meal["strIngredient3"] + ', '
            four_i = meal["strMeasure4"] + ' ' + meal["strIngredient4"] + ', '
            five_i = meal["strMeasure5"] + ' ' + meal["strIngredient5"]

            meal_ingredients = one_i + two_i + three_i + four_i + five_i
        
            i += 1
            all_categories = Recipe.all_categories
            new_recipe = Recipe.create(category: meal_category, name: meal_name, region: meal_area, ingredient_list: meal_ingredients, time: rand(20..80), instruction: meal_instructions)
            new_recipe.reload
            end
          end
        end
    
    end
    
end