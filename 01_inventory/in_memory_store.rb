class InMemoryStore
  def initialize(records)
    @records = records
  end

  def create(record)
    records << record
  end

  def all_articles
    records
  end

  private

  attr_reader :records
end
