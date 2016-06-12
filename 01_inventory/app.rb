require "sinatra"
require_relative "inventory"
require_relative "in_memory_store"

INITIAL_RECORDS = [
  {"name" => "Camisa 1", "code" => "c1", "quantity" => 10},
  {"name" => "Gorra 1", "code" => "g1", "quantity" => 35}
]

store = InMemoryStore.new(INITIAL_RECORDS)
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
