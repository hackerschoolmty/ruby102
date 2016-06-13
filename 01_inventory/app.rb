require "sinatra"
require_relative "lib/inventory"
require_relative "store/db_store/config"
require_relative "store/db_store"

store = DbStore.new
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

after do
  ActiveRecord::Base.clear_active_connections!
end
