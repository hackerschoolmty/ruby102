module Presence
  def present?(value)
    case value
    when String then !value.empty?
    else !value.nil?
    end
  end
end

class Inventory
  def initialize(store)
    @store = store
  end

  def articles_list
    store.all_articles.map { |record| Article.new(record) }
  end

  def new_article_form
    ArticleForm.new(Article.new)
  end

  def add_article(params)
    article = Article.new(params)
    errors = ArticleValidator.new(article, store).validate!

    if errors.empty?
      store.create(params)
      SuccessStatus.new
    else
      ErrorStatus.new(ArticleForm.new(article, errors))
    end
  end

  def increment_article_quantity(code)
    article = Article.new(store.find_with_code(code))
    article.increment_quantity!
    store.update(article.to_record)
  end

  private

  attr_reader :store
end

class ArticleValidator
  include Presence

  def initialize(article, store)
    @article = article
    @store = store
    @errors = {}
  end

  def validate!
    validate_presence_of! :name, :code, :quantity
    validate_uniqueness_of_code!
    validate_quantity_is_greater_or_equals_than_zero!
    errors
  end

  private

  attr_reader :article, :store, :errors

  def validate_uniqueness_of_code!
    if store.find_with_code(article.code)
      errors[:code] = "ya esta tomado"
    end
  end

  def validate_quantity_is_greater_or_equals_than_zero!
    if present?(article.quantity) && article.quantity < 0
      errors[:quantity] = "debe ser mayor o igual a 0"
    end
  end

  def validate_presence_of!(*attr_keys)
    attr_keys.map do |attr_key|
      unless present? article.send(attr_key)
        errors[attr_key] = "no puede estar en blanco"
      end
    end
  end
end

module Form
  def has_errors_for(*attr_keys)
    attr_keys.each do |attr_key|
      define_method "#{attr_key}_errors" do
        errors[attr_key] || ""
      end

      define_method "has_#{attr_key}_errors?" do
        present? send("#{attr_key}_errors")
      end
    end
  end

  def has_fields(*attr_keys, source:)
    attr_keys.each do |attr_key|
      define_method attr_key do
        send(source).send(attr_key).to_s
      end
    end
  end
end

class ArticleForm
  include Presence
  extend Form

  def initialize(article, errors = {})
    @article = article
    @errors = errors
  end

  has_fields :name, :code, :quantity, source: :article
  has_errors_for :name, :code, :quantity

  private

  attr_reader :errors, :article
end

class SuccessStatus
  def success?
    true
  end
end

class ErrorStatus
  attr_reader :form_with_errors

  def initialize(form)
    @form_with_errors = form
  end

  def success?
    false
  end
end

class Article
  include Presence
  attr_reader :name, :code, :quantity

  def initialize(record = {})
    @name = record["name"]
    @code = record["code"]
    self.quantity = record["quantity"]
  end

  def increment_quantity!
    self.quantity = quantity + 1
  end

  def to_record
    {"name" => name,
     "code"=> code,
     "quantity"=> quantity}
  end

  private

  def quantity=(value)
    if present? value
      @quantity = value.to_i
    end
  end
end
