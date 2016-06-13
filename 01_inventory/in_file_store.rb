require "yaml"

class InFileStore
  def create(record)
    update_records do |records|
      records << record
    end
  end

  def update(record)
    update_records do |records|
      index = find_index(record)
      records[index] = record
    end
  end

  def all_articles
    load_records
  end

  def find_with_code(code)
    load_records.detect do |record|
      record["code"] == code
    end
  end

  private

  attr_reader :records

  def find_index(record)
    load_records.find_index do |current|
      current["code"] == record["code"]
    end
  end

  def update_records(&block)
    records = load_records
    block.call(records)
    save records
  end

  def save(records)
    File.open(file_path, "w") do |file|
      file << YAML.dump(records)
    end
  end

  def load_records
    File.open(file_path) do |file|
      YAML.load(file.read) || []
    end
  end

  def file_path
    "./in_file_store/data.yml"
  end
end
