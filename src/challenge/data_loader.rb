# frozen_string_literal: true

require 'json'

# DataLoader loads a collection of records from `filename`
# using `factory` to create objects from the JSON records.
#
# Usage: DataLoader.load_or_exit_on_error is a convenience
# method for handling some errors when loading data from
# the file.
class DataLoader
  attr_reader :filename, :valid_data, :invalid_data, :errors, :factory

  def self.load_or_exit_on_error(factory, filename)
    loader = DataLoader.new(factory, filename).load

    return loader unless loader.errors?

    puts "\n\nErrors detected when loading data from #{filename.inspect}"
    puts loader.errors.join("\n")
    puts "\nInvalid records" if loader.invalid_data.any?
    loader.invalid_data.each { |d| puts d.inspect }
    exit 1
  end

  def initialize(factory, filename)
    @factory = factory
    @filename = filename
    @errors = []
    @valid_data = []
    @invalid_data = []
  end

  def errors?
    errors.any? || invalid_data.any?
  end

  def load
    @valid_data, @invalid_data =
      parsed_data
      .map.with_index(1, &method(:create_objects))
      .partition(&:valid?)

    self
  rescue Errno::ENOENT
    @errors << "Could not find #{filename.inspect}"
    self
  rescue StandardError => e
    @errors << e
    self
  end

  private

  def create_objects(data, index)
    factory.create(data)
  rescue StandardError => e
    @errors << "Invalid record at index #{index}: #{e.message}"
    factory.invalid_null_object
  end

  def parsed_data
    JSON.parse(File.read(filename))
  end
end
