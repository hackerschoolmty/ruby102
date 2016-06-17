class Inventory
  def initialize(store)
    @store = store
  end

  def articles_list
    store.all_articles.map { |record| Article.new(record) }
  end

  def add_article(params)
    store.create(params)
    SuccessStatus.new
  end

  private

  attr_reader :store
end

class SuccessStatus
  def success?
    true
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
