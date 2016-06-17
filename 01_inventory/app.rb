require "sinatra"
require_relative "inventory"
require_relative "in_memory_store"

INITIAL_RECORDS = [
  {"name" => "Camisa 1", "code" => "c1", "quantity" => 1},
  {"name" => "Gorra 1",  "code" => "g1", "quantity" => 5},
  {"name" => "Gorra 2",  "code" => "g2", "quantity" => 5}]

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
  status = inventory.add_article(params)

  if status.success?
    redirect "/"
  else
    erb :new_article
  end
end
