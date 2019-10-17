require 'csv'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    load
  end

  def all
    @recipes
  end

  def find(recipe_index)
    @recipe = @recipes[recipe_index]
  end

  def add_recipe(recipe)
    @recipes << recipe
    save
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    save
  end

  def load
    CSV.foreach(@csv_file_path) do |row|
      recipe = Recipe.new(row[0], row[1], row[2], row[3], row[4] == "true")
      add_recipe(recipe)
    end
  end

  def save
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.difficulty, recipe.done?]
      end
    end
  end
end
