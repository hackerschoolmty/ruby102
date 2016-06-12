require "sinatra"
require_relative "inventory"

INITIAL_RECORDS = [
  {"name" => "Camisa 1", "code" => "c1", "quantity" => 10},
  {"name" => "Gorra 1", "code" => "g1", "quantity" => 35}
]

class Store
  def initialize(records)
    @records = records
  end

  def create(record)
    records << record
  end

  def all_articles
    records
  end

  private

  attr_reader :records
end

store = Store.new(INITIAL_RECORDS)
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
