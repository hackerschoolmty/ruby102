class Inventory
  def initialize(store)
    @store = store
  end

  def articles_list
    store.all_articles.map { |raw| Article.new(raw) }
  end

  def new_article_form
    ArticleForm.new
  end

  def add_article(params)
    form = ArticleForm.new(params)

    if form.valid?
      store.create(params)
      SuccessArticleStatus.new
    else
      ErrorArticleStatus.new(form)
    end
  end

  private

  attr_reader :store
end

class ArticleForm
  attr_reader :name, :code, :quantity

  def initialize(data = {})
    @name = data["name"]
    @code = data["code"]
    self.quantity = data["quantity"]
  end

  def valid?
    present?(name)
  end

  def name_errors
    "can't be blank" unless present? name
  end

  private

  def present?(attr)
    !attr.nil? && attr != ""
  end

  def quantity=(value)
    @quantity = value.to_i if value
  end
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

  def initialize(data)
    @name = data["name"]
    @code = data["code"]
    @quantity = data["quantity"]
  end
end
