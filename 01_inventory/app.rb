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
  @form = inventory.new_article_form
  erb :new_article
end

post '/articles' do
  status = inventory.add_article(params)

  if status.success?
    redirect "/"
  else
    @form = status.form_with_errors
    erb :new_article
  end
end

post '/articles/:code/increment' do
  inventory.increment_article_quantity(params[:code])
  redirect "/"
end

post '/articles/:code/decrement' do
  inventory.decrement_article_quantity(params[:code])
  redirect "/"
end
