class Recipe < ActiveRecord::Base 
    has_many :favorites
    has_many :users, through: :favorites

    def self.all_categories
        self.all.map {|recipe| recipe.category}.uniq
    end

    def self.random_recipe
      self.all.select do |recipe|
        recipe
      end 
    end

    def self.sort_by_cooktime(time)
        self.all.select do |recipe| 
            if recipe.time <= time
                recipe
            end
      end.sample
    end

    def self.all_ingredients 
      self.all.map do |recipe|
            "#{recipe.name} - #{recipe.ingredient_list}"
      end
  end
    
end