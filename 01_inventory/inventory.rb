module Presence
  def present?(value)
    !value.nil? && !value.empty?
  end
end

class Inventory
  include Presence

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
    errors = validate_article(article)

    if errors.empty?
      store.create(params)
      SuccessStatus.new
    else
      ErrorStatus.new(ArticleForm.new(article, errors))
    end
  end

  private

  attr_reader :store

  def validate_article(article)
    errors = {}

    unless present? article.name
      errors[:name] = "no puede estar en blanco"
    end

    unless present? article.code
      errors[:code] = "no puede estar en blanco"
    end

    unless present? article.quantity
      errors[:quantity] = "no puede estar en blanco"
    end

    errors
  end
end

class ArticleForm
  include Presence
  attr_reader :name, :code, :quantity

  def initialize(article, errors = {})
    @name = article.name || ""
    @code = article.code || ""
    @quantity = article.quantity || ""
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
  attr_reader :name, :code, :quantity

  def initialize(record = {})
    @name = record["name"]
    @code = record["code"]
    @quantity = record["quantity"]
  end
end
