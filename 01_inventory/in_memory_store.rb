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

  def find_with_code(code)
    records.detect do |record|
      record["code"] == code
    end
  end

  private

  attr_reader :records
end
