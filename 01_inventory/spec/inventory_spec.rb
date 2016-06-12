require "rspec"
require_relative "../inventory"
require_relative "../in_memory_store"

RSpec.describe "Inventory" do
  describe "shows the articles" do
    attr_reader :articles

    before do
      inventory = Inventory.new(store_with([
        {"name" => "Camisa 1", "code" => "c1", "quantity" => 10},
        {"name" => "Gorra 1", "code" => "g1", "quantity" => 35}
      ]))

      @articles = inventory.articles_list
    end

    it "with name" do
      expect(articles.map(&:name)).to eq ["Camisa 1", "Gorra 1"]
    end

    it "with code" do
      expect(articles.map(&:code)).to eq ["c1", "g1"]
    end

    it "with quantity" do
      expect(articles.map(&:quantity)).to eq [10, 35]
    end
  end

  describe "adds article" do
    it "with name, code and quantity" do
      store = store_with([])
      inventory = Inventory.new(store)
      params = {
        "name" => "Camisa 1",
        "code" => "c1",
        "quantity" => "10"
      }

      expect(inventory.articles_list).to be_empty
      expect(store).to receive(:create).with(params)
      inventory.add_article(params)
    end
  end

  def store_with(records)
    InMemoryStore.new(records)
  end
end
