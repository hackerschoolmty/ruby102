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

    it "has a new article form" do
      form = inventory.new_article_form
      expect(form.name).to eq ""
      expect(form.code).to eq ""
      expect(form.quantity).to eq ""
    end

    it "has a new article form without errors" do
      form = inventory.new_article_form
      expect(form).not_to have_name_errors
      expect(form.name_errors).to eq ""

      expect(form).not_to have_code_errors
      expect(form.code_errors).to eq ""

      expect(form).not_to have_quantity_errors
      expect(form.quantity_errors).to eq ""
    end

    it "with name, code and quantity" do
      expect(store).to receive(:create).with(good_params)
      inventory.add_article(good_params)
    end

    it "returns success when params are good" do
      status = inventory.add_article(good_params)
      expect(status).to be_success
    end

    it "returns not success when name is not present (nil)" do
      bad_params = good_params.merge("name" => nil)
      status = inventory.add_article(bad_params)
      expect(status).not_to be_success
    end

    it "returns not success when name is not present (empty)" do
      bad_params = good_params.merge("name" => "")
      status = inventory.add_article(bad_params)
      expect(status).not_to be_success
    end

    it "on error does not create the article" do
      bad_params = good_params.merge("name" => "")
      expect(store).not_to receive(:create)
      inventory.add_article(bad_params)
    end

    it "on error returns a form with the current value" do
      bad_params = good_params.merge("name" => "")
      status = inventory.add_article(bad_params)
      form = status.form_with_errors
      expect(form.name).to eq ""
      expect(form.code).to eq good_params["code"]
      expect(form.quantity).to eq good_params["quantity"]
    end

    it "validates presences of name" do
      bad_params = good_params.merge("name" => "")
      status = inventory.add_article(bad_params)
      form = status.form_with_errors
      expect(form).to have_name_errors
      expect(form).not_to have_code_errors
      expect(form).not_to have_quantity_errors
      expect(form.name_errors).to eq "no puede estar en blanco"
    end

    it "validates presences of code" do
      bad_params = good_params.merge("code" => "")
      status = inventory.add_article(bad_params)
      form = status.form_with_errors
      expect(form).to have_code_errors
      expect(form).not_to have_name_errors
      expect(form).not_to have_quantity_errors
      expect(form.code_errors).to eq "no puede estar en blanco"
    end

    it "validates presences of quantity" do
      bad_params = good_params.merge("quantity" => "")
      status = inventory.add_article(bad_params)
      form = status.form_with_errors
      expect(form).to have_quantity_errors
      expect(form).not_to have_name_errors
      expect(form).not_to have_code_errors
      expect(form.quantity_errors).to eq "no puede estar en blanco"
    end

    it "validates quantity is greater or equals than 0" do
      bad_params = good_params.merge("quantity" => "-1")
      status = inventory.add_article(bad_params)
      form = status.form_with_errors
      expect(form).to have_quantity_errors
      expect(form.quantity_errors).to eq "debe ser mayor o igual a 0"
    end

    it "validates uniqueness of code" do
      store = store_with([{"name" => "Camisa 1", "code" => "c1", "quantity" => 1}])
      inventory = Inventory.new(store)
      params = good_params.merge("code" => "c1")

      status = inventory.add_article(params)
      form = status.form_with_errors

      expect(form).to have_code_errors
      expect(form.code_errors).to eq "ya esta tomado"
    end
  end

  def store_with(records)
    InMemoryStore.new(records)
  end
end
