require 'json'
require 'rest-client'



User.destroy_all
Recipe.destroy_all
Favorite.destroy_all


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
      meal_ingredients = meal["strIngredient1"]

      i += 1
      Recipe.create(category: meal_category, name: meal_name, region: meal_area, ingredient_list: meal_ingredients, time: rand(20..80), instruction: meal_instructions)
    end
  end
end
