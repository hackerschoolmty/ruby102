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
    errors = validate_article(article)

    if errors.empty?
      store.create(params)
      SuccessArticleStatus.new
    else
      ErrorArticleStatus.new(ArticleForm.new(article, errors))
    end
  end

  private

  attr_reader :store

  def validate_article(article)
    if present?(article.name)
      {}
    else
      {name: "can't be blank"}
    end
  end

  def present?(attr)
    !attr.nil? && attr != ""
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
  attr_reader :name, :code, :quantity

  def initialize(data = {})
    @name = data["name"]
    @code = data["code"]
    self.quantity = data["quantity"]
  end

  private

  def quantity=(value)
    @quantity = value.to_i if value
  end
end
