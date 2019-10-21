require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

require_relative "cookbook"
require_relative "recipe"
require_relative "scrape_letscookfrench_service"

get '/' do
  cookbook = Cookbook.new("recipes.csv")
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time], params[:difficulty])
  cookbook = Cookbook.new("recipes.csv")
  cookbook.add_recipe(recipe)
  redirect to '/'
end

get '/recipes/:index' do
  cookbook = Cookbook.new("recipes.csv")
  recipe = cookbook.remove_recipe(params[:index].to_i)
  redirect to '/'
end

get '/search' do
  @ingredient = params[:ingredient]
  @results = ScrapeLetscookfrenchService.new(params[:ingredient]).call unless @ingredient.nil?
  erb :search
end

post '/search/import/:recipe_name' do
  recipe = Recipe.new(params[:recipe_name], params[:recipe_description], params[:recipe_prep_time], params[:recipe_difficulty])
  cookbook = Cookbook.new("recipes.csv")
  cookbook.add_recipe(recipe)
  redirect to '/'
end

get '/recipes/:index/done' do
  cookbook = Cookbook.new("recipes.csv")
  recipe = cookbook.find(params[:index].to_i)
  recipe.mark_as_done!
  cookbook.save
  redirect to '/'
end
