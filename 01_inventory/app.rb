require "sinatra"
require_relative "inventory"

class Store
  def all_articles
    [{name: "Camisa 1", code: "c1", quantity: 10},
     {name: "Gorra 1", code: "g1", quantity: 35}]
  end
end

get '/' do
  store = Store.new
  inventory = Inventory.new(store)
  @articles = inventory.articles_list
  erb :index
end

get '/articles/new' do
  erb :new_article
end
