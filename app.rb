require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "recipe"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  cookbook = Cookbook.new("recipes.csv")
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

get '/recipes/:index' do
  cookbook = Cookbook.new("recipes.csv")
  recipe = cookbook.remove_recipe(params[:index].to_i)
  redirect to '/'
end

post '/recipes' do
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time], params[:difficulty])
  cookbook = Cookbook.new("recipes.csv")
  cookbook.add_recipe(recipe)
  redirect to '/'
end
