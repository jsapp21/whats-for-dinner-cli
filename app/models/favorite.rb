class Favorite < ActiveRecord::Base
    belongs_to :user 
    belongs_to :recipe

    def add_note_to_recipe(note)
        self.user_note = note
        self.save
    end
    
end