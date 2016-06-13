require "active_record"

class DbArticle < ActiveRecord::Base
  self.table_name = "articles"
end

class DbStore
  def create(record)
    DbArticle.create(record)
  end

  def update(record)
    article = find_with_code(record["code"])
    article.update_attributes(record)
  end

  def all_articles
    DbArticle.all
  end

  def find_with_code(code)
    DbArticle.find_by code: code
  end
end
