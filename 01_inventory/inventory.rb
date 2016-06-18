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

class ArticleForm
  include Presence
  attr_reader :name, :code, :quantity

  def initialize(article, errors = {})
    @name = article.name.to_s
    @code = article.code.to_s
    @quantity = article.quantity.to_s
    @errors = errors
  end

  def has_name_errors?
    present? name_errors
  end

  def has_code_errors?
    present? code_errors
  end

  def has_quantity_errors?
    present? quantity_errors
  end

  def code_errors
    errors[:code] || ""
  end

  def quantity_errors
    errors[:quantity] || ""
  end

  def name_errors
    errors[:name] || ""
  end

  private

  attr_reader :errors
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

  private

  def quantity=(value)
    if present? value
      @quantity = value.to_i
    end
  end
end
