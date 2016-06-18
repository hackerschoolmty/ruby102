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

  def update(record)
    index = find_index(record)
    records[index] = record
  end

  def find_with_code(code)
    records.detect do |record|
      record["code"] == code
    end
  end

  private

  attr_reader :records

  def find_index(record)
    records.find_index do |current|
      current["code"] == record["code"]
    end
  end
end
