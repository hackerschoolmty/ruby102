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
      expect(store).to receive(:create).with(good_params.merge("quantity" => 10))
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

    it "on error does not return success" do
      params = good_params.merge("name" => nil)
      status = inventory.add_article(params)
      expect(status).not_to be_success
    end

    it "on error does not create the article" do
      params = good_params.merge("name" => nil)
      expect(store).not_to receive(:create).with(params)
      inventory.add_article(params)
    end

    it "on error returns a form with the current values" do
      params = good_params.merge("name" => nil)
      status = inventory.add_article(params)
      form = status.form_with_errors
      expect(form.name).to eq nil
      expect(form.code).to eq "c1"
      expect(form.quantity).to eq 10
    end

    [nil, ""].each do |blank|
      it "validates presence of name" do
        params = good_params.merge("name" => blank)
        status = inventory.add_article(params)
        form = status.form_with_errors
        expect(form.name_errors).to eq "can't be blank"
      end
    end

    [nil, ""].each do |blank|
      it "validates presence of code" do
        params = good_params.merge("code" => blank)
        status = inventory.add_article(params)
        form = status.form_with_errors
        expect(form.code_errors).to eq "can't be blank"
      end
    end

    [nil, ""].each do |blank|
      it "validates presence of quantity" do
        params = good_params.merge("quantity" => blank)
        status = inventory.add_article(params)
        form = status.form_with_errors
        expect(form.quantity_errors).to eq "can't be blank"
      end
    end

    it "validates quantity is greater or equals than 0" do
      params = good_params.merge("quantity" => -1)
      status = inventory.add_article(params)
      form = status.form_with_errors
      expect(form.quantity_errors).to eq "should be greater or equals than 0"
    end

    it "validates that the code is unique" do
      params = good_params.merge("code" => "c1")
      status = inventory.add_article(params)
      expect(status).to be_success

      status = inventory.add_article(params)
      form = status.form_with_errors
      expect(form.code_errors).to eq "already taken"
    end
  end

  describe "modifies articles quantity" do
    attr_reader :store, :inventory

    before do
      @store = store_with([
        {"name" => "Camisa 1", "code" => "c1", "quantity" => 10},
        {"name" => "Gorra 1", "code" => "g1", "quantity" => 0}])
      @inventory = Inventory.new(store)
    end

    it "incrementing it" do
      expect(store).
        to receive(:update).
        with({
          "name" => "Camisa 1",
          "code" => "c1",
          "quantity" => 11})
      inventory.increment_article_quantity("c1")
    end

    it "decrementing it" do
      expect(store).
        to receive(:update).
        with({
          "name" => "Camisa 1",
          "code" => "c1",
          "quantity" => 9})
      inventory.decrement_article_quantity("c1")
    end

    it "decrementing it (unless is 0)" do
      expect(store).not_to receive(:update)
      inventory.decrement_article_quantity("g1")
    end
  end

  def store_with(records)
    InMemoryStore.new(records)
  end
end
