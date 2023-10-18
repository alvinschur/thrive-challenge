# frozen_string_literal: true

# Company stores data related to a single company.  Currently implemented
# using ruby's `Data` clas to gain some immutability.
#
# This could be implemented using `ActiveModel`` to gain improved data validation.
class Company < Data.define(:id, :name, :top_up, :email_status)
  INTEGER_FIELDS = %i[id top_up].freeze
  STRING_FIELDS = %i[name].freeze
  BOOLEAN_FIELDS = %i[email_status].freeze

  def valid?
    return false unless field_classes(STRING_FIELDS) == [String]
    return false unless field_classes(INTEGER_FIELDS) == [Integer]
    return false unless (field_classes(BOOLEAN_FIELDS) - [TrueClass, FalseClass]).empty?
    return false if top_up.negative?

    true
  end

  private

  def field_classes(fields)
    fields.map(&method(:public_send)).map(&:class).uniq
  end
end
