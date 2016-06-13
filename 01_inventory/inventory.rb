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

  private

  attr_reader :store
end

module Presence
  def present?(attr)
    !attr.nil? && attr != ""
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
    validate_name!
    validate_code!
    validate_quantity!
    errors
  end

  private

  attr_reader :article, :store
  attr_accessor :errors

  def validate_name!
    unless present?(article.name)
      errors[:name] = "can't be blank"
    end
  end

  def validate_code!
    if present?(article.code)
      if store.find_with_code(article.code)
        errors[:code] = "already taken"
      end
    else
      errors[:code] = "can't be blank"
    end
  end

  def validate_quantity!
    if present?(article.quantity)
      if article.quantity < 0
        errors[:quantity] = "should be greater or equals than 0"
      end
    else
      errors[:quantity] = "can't be blank"
    end
  end
end

class ArticleForm
  def initialize(article, errors = {})
    @article = article
    @errors = errors
  end

  def name
    article.name
  end

  def code
    article.code
  end

  def quantity
    article.quantity
  end

  def valid?
    present?(name)
  end

  def name_errors
    errors[:name]
  end

  def code_errors
    errors[:code]
  end

  def quantity_errors
    errors[:quantity]
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

  private

  def quantity=(value)
    @quantity = value.to_i if present?(value)
  end
end
