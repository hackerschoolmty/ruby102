require "rspec"

class Inventory
  def initialize(store)
    @store = store
  end

  def articles_list
    store.all_articles.map { |raw| Article.new(raw) }
  end

  private

  attr_reader :store
end

class Article
  attr_reader :name, :code

  def initialize(data)
    @name = data[:name]
    @code = data[:code]
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

    it "with code" do
      store = store_with([{code: "c1"}, {code: "g1"}])
      inventory = Inventory.new(store)
      articles = inventory.articles_list
      expect(articles.map(&:code)).to eq ["c1", "g1"]
    end

    it "with quantity"

    def store_with(records)
      FakeStore.new(records)
    end
  end
end
