require "rspec"
require_relative "../inventory"
require_relative "../in_memory_store"

RSpec.describe "Inventory" do
  describe "shows the articles" do
    attr_reader :articles

    before do
      store = store_with([
        {"name" => "Camisa 1", "code" => "c1", "quantity" => 1},
        {"name" => "Gorra 1", "code" => "g1", "quantity" => 5}])
      inventory = Inventory.new(store)
      @articles = inventory.articles_list
    end

    it "with name" do
      expect(articles.map(&:name)).to eq ["Camisa 1", "Gorra 1"]
    end

    it "with code" do
      expect(articles.map(&:code)).to eq ["c1", "g1"]
    end

    it "with quantity" do
      expect(articles.map(&:quantity)).to eq [1, 5]
    end
  end

  describe "adds article" do
    it "with name, code and quantity" do
      store = store_with([])
      inventory = Inventory.new(store)

      expect(store).to receive(:create).with({
        "name" => "Camisa 1",
        "code" => "c1",
        "quantity" => "10"
      })

      inventory.add_article({
        "name" => "Camisa 1",
        "code" => "c1",
        "quantity" => "10"
      })
    end
  end

  def store_with(records)
    InMemoryStore.new(records)
  end
end
