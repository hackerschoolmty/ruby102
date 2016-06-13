require "ostruct"

class Inventory
  def initialize(store)
    @store = store
  end

  def articles_list
    store.all_articles.map { |raw| Article.new(raw) }
  end

  def new_article_form
    ArticleForm.new(Article.new)
  end

  def add_article(params)
    article = Article.new(params)
    errors = ArticleValidator.new(article, store).validate!

    if errors.empty?
      store.create(params)
      SuccessArticleStatus.new
    else
      ErrorArticleStatus.new(ArticleForm.new(article, errors))
    end
  end

  def increment_article_quantity(code)
    article = Article.new(store.find_with_code(code))
    article.increment_quantity!
    store.update(article.to_h)
  end

  private

  attr_reader :store
end

module Presence
  def present?(attr)
    !attr.nil? && attr != ""
  end
end

module Delegate
  def delegate(*keys, to:, sufix: false)
    keys.each do |key|
      method_name = sufix && "#{key}_#{to}" || key
      define_method method_name do
        self.send(to).send(key)
      end
    end
  end
end

class ArticleValidator
  include Presence

  def initialize(article, store)
    @store = store
    @article = article
  end

  def validate!
    self.errors = {}
    validate_presence_of! :name, :code, :quantity
    validate_uniqness_of_code!
    validate_quantity_is_greater_than_or_equals_than_zero!
    errors
  end

  private

  attr_reader :article, :store
  attr_accessor :errors

  def validate_presence_of!(*attr_keys)
    attr_keys.each do |attr_key|
      unless present?(article.send(attr_key))
        errors[attr_key] = "can't be blank"
      end
    end
  end

  def validate_uniqness_of_code!
    if present?(article.code) && store.find_with_code(article.code)
      errors[:code] = "already taken"
    end
  end

  def validate_quantity_is_greater_than_or_equals_than_zero!
    if present?(article.quantity) && article.quantity < 0
      errors[:quantity] = "should be greater or equals than 0"
    end
  end
end

class ArticleForm
  extend Delegate

  delegate :name, :code, :quantity, to: :article
  delegate :name, :code, :quantity, to: :errors, sufix: true

  def initialize(article, errors = {})
    @article = article
    @errors = OpenStruct.new(errors)
  end

  private

  attr_reader :article, :errors
end

class ErrorArticleStatus
  attr_reader :form_with_errors

  def initialize(form)
    @form_with_errors = form
  end

  def success?
    false
  end
end

class SuccessArticleStatus
  def success?
    true
  end
end

class Article
  include Presence

  attr_reader :name, :code, :quantity

  def initialize(data = {})
    @name = data["name"]
    @code = data["code"]
    self.quantity = data["quantity"]
  end

  def to_h
    {"name" => name, "code" => code, "quantity" => quantity}
  end

  def increment_quantity!
    self.quantity = quantity + 1
  end

  private

  def quantity=(value)
    @quantity = value.to_i if present?(value)
  end
end
