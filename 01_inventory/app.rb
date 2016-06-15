require "sinatra"
require_relative "inventory"

class Store
  def all_articles
    [{name: "Camisa 1", code: "c1", quantity: 1},
     {name: "Gorra 1", code: "g1", quantity: 5},
     {name: "Gorra 2", code: "g2", quantity: 5}]
  end
end

get '/' do
  store = Store.new
  inventory = Inventory.new(store)
  @articles = inventory.articles_list
  erb :index
end
