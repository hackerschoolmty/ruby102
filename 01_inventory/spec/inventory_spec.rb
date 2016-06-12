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
    attr_reader :store, :inventory, :good_params

    before do
      @store = store_with([])
      @inventory = Inventory.new(store)
      @good_params = {
        "name" => "Camisa 1",
        "code" => "c1",
        "quantity" => "10"
      }
    end

    it "with name, code and quantity" do
      expect(store).to receive(:create).with(good_params)
      inventory.add_article(good_params)
    end

    it "returns success when params are good" do
      status = inventory.add_article(good_params)
      expect(status).to be_success
    end

    it "has a new empty article form" do
      form = inventory.new_article_form
      expect(form.name).to be_nil
      expect(form.name_errors).to be_nil
      expect(form.code).to be_nil
      expect(form.quantity).to be_nil
    end

    describe "validates presence of name" do
      [nil, ""].each do |blank|
        it "on error does not return success" do
          params = good_params.merge("name" => blank)
          status = inventory.add_article(params)
          expect(status).not_to be_success
        end

        it "on error does not create the article" do
          params = good_params.merge("name" => blank)
          expect(store).not_to receive(:create).with(params)
          inventory.add_article(params)
        end

        it "on error returns a form with the current values" do
          params = good_params.merge("name" => blank)
          status = inventory.add_article(params)
          form = status.form_with_errors
          expect(form.name).to eq blank
          expect(form.code).to eq "c1"
          expect(form.quantity).to eq 10
        end

        it "on error returns a form with errors" do
          params = good_params.merge("name" => blank)
          status = inventory.add_article(params)
          form = status.form_with_errors
          expect(form.name_errors).to eq "can't be blank"
        end
      end
    end
  end

  def store_with(records)
    InMemoryStore.new(records)
  end
end
