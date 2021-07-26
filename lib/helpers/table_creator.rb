# frozen_string_literal: true

require 'terminal-table'

module Helpers
  class TableCreator
    def self.call(collection, with_numbers: true)
      headings = with_numbers ? ['number'] : []
      headings += collection.first.attributes.keys
      rows = collection.map.with_index do |object, index|
        row = with_numbers ? [index + 1] : []
        row + object.attributes.values
      end
      Terminal::Table.new(headings: headings, rows: rows)
    end
  end
end
