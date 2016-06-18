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

  def present?(value)
    !value.nil? && !value.empty?
  end

  def validate_article(article)
    if present? article.name
      {}
    else
      {name: "no puede estar en blanco"}
    end
  end
end

class ArticleForm
  attr_reader :name, :code, :quantity

  def initialize(article, errors = {})
    @name = article.name || ""
    @code = article.code || ""
    @quantity = article.quantity || ""
    @errors = errors
  end

  def has_name_errors?
    errors.size > 0
  end

  def name_errors
    if has_name_errors?
      "no puede estar en blanco"
    else
      ""
    end
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
