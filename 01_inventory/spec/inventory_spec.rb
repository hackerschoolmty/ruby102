require "rspec"
require_relative "../inventory"

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
    attr_reader :articles

    before do
      inventory = Inventory.new(store_with([
        {name: "Camisa 1", code: "c1", quantity: 10},
        {name: "Gorra 1", code: "g1", quantity: 35}
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

    def store_with(records)
      FakeStore.new(records)
    end
  end
end
