class Inventory
  def initialize(store)
    @store = store
  end

  def articles_list
    store.all_articles.map { |record| Article.new(record) }
  end

  def new_article_form
    ArticleForm.new
  end

  def add_article(params)
    form = ArticleForm.new(params)

    if present? params["name"]
      store.create(params)
      SuccessStatus.new
    else
      ErrorStatus.new(form)
    end
  end

  private

  attr_reader :store

  def present?(value)
    !value.nil? && !value.empty?
  end
end

class ArticleForm
  attr_reader :name, :code, :quantity

  def initialize(params = {})
    @name = ""
    @code = params["code"] || ""
    @quantity = params["quantity"] || ""
  end

  def has_name_errors?
    true
  end

  def name_errors
    "no puede estar en blanco"
  end
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

  def initialize(record)
    @name = record["name"]
    @code = record["code"]
    @quantity = record["quantity"]
  end
end
