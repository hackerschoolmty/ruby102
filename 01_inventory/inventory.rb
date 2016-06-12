class Inventory
  def initialize(store)
    @store = store
  end

  def articles_list
    store.all_articles.map { |raw| Article.new(raw) }
  end

  def add_article(params)
    store.create(params)

    if params["name"]
      AddArticleStatus.new(:success)
    else
      AddArticleStatus.new(:error)
    end
  end

  private

  attr_reader :store
end

class AddArticleStatus
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

  def initialize(data)
    @name = data["name"]
    @code = data["code"]
    @quantity = data["quantity"]
  end
end
