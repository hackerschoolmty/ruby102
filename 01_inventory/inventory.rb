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
    store.create(params)

    if present? params["name"]
      Response.new(:success)
    else
      Response.new(:error)
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

  def initialize
    @name = ""
    @code = ""
    @quantity = ""
  end
end

class Response
  def initialize(status)
    @status = status
  end

  def success?
    status == :success
  end

  private

  attr_reader :status
end

class Article
  attr_reader :name, :code, :quantity

  def initialize(record)
    @name = record["name"]
    @code = record["code"]
    @quantity = record["quantity"]
  end
end
