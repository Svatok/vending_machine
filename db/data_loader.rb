# frozen_string_literal: true

require 'yaml'

class DataLoader
  DATA_FILE_NAME = 'data.yml'
  OBJECT_MAPPER = {
    products: Product,
    coins: Coin
  }.freeze

  def self.load
    data = YAML.safe_load(File.read(File.join(File.dirname(__FILE__), DATA_FILE_NAME)), symbolize_names: true)
    data.map do |key, rows|
      initialize_objects(rows, OBJECT_MAPPER[key])
    end
  end

  def self.initialize_objects(rows, klass)
    rows.map do |row|
      klass.new(row)
    end
  end
end
