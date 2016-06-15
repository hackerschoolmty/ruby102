require "rspec"

class Inventory
  def initialize(store)
    @store = store
  end

  def articles_list
    store.all_articles.map { |record| Article.new(record) }
  end

  private

  attr_reader :store
end

class Article
  attr_reader :name

  def initialize(record)
    @name = record[:name]
  end
end

RSpec.describe "Inventory" do
  class FakeStore
    def initialize(records)
      @records = records
    end

    def all_articles
      records
    end

    private

    attr_reader :records
  end

  describe "shows the articles" do
    it "with name" do
      store = store_with([{name: "Camisa 1"}, {name: "Gorra 1"}])
      inventory = Inventory.new(store)
      articles = inventory.articles_list
      expect(articles.map(&:name)).to eq ["Camisa 1", "Gorra 1"]
    end

    it "with code"
    it "with quantity"

    def store_with(records)
      FakeStore.new(records)
    end
  end
end
