class InMemoryStore
  def initialize(records)
    @records = records
  end

  def all_articles
    records
  end

  def create(record)
    records << record
  end

  private

  attr_reader :records
end
