require 'json'
require 'rest-client'



User.destroy_all
Recipe.destroy_all
Favorite.destroy_all


api_key = ENV["API_KEY"]
api_url = "https://www.themealdb.com/api/json/v2/#{api_key}/"

find_ten_random = api_url + "randomselection.php"

# 3.times do
#   recipe_data = RestClient.get(find_ten_random)
#   parsed_recipe = JSON.parse(recipe_data.body)
#   parsed_recipe.map do |meal_hash|
        
#     i = 0
#     while i < 10 do
#       meal = meal_hash[1][i]
#       meal_name = meal["strMeal"]
#       meal_category = meal["strCategory"]
#       meal_instructions = meal["strInstructions"]
#       meal_area = meal["strArea"]
#       meal_ingredients = meal["strIngredient1"]

#       i += 1
#       Recipe.create(category: meal_category, name: meal_name, region: meal_area, ingredient_list: meal_ingredients, time: rand(20..80), instruction: meal_instructions)
#     end
#   end
# end


3.times do
  recipe_data = RestClient.get(find_ten_random)
  parsed_recipe = JSON.parse(recipe_data.body)
  parsed_recipe.map do |meal_hash|
     
      i = 0
      while i < 10 do
      meal = meal_hash[1][i]
      meal_name = meal["strMeal"]
      meal_category = meal["strCategory"]

      instruction = meal["strInstructions"].gsub(/\r/,"")
      instruction2 = instruction.gsub(/\n/,"")
      meal_instructions = instruction2

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