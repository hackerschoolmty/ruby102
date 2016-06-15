require "sinatra"
require_relative "inventory"

class Store
  def initialize
    @records = [
     {"name" => "Camisa 1", "code" => "c1", "quantity" => 1},
     {"name" => "Gorra 1",  "code" => "g1", "quantity" => 5},
     {"name" => "Gorra 2",  "code" => "g2", "quantity" => 5}]
  end

  def all_articles
    records
  end

  def create(record)
    records << record
  end

  private

  attr_reader :records
end

store = Store.new
inventory = Inventory.new(store)

get '/' do
  @articles = inventory.articles_list
  erb :index
end

get '/articles/new' do
  erb :new_article
end

post '/articles' do
  inventory.add_article(params)
  redirect "/"
end
