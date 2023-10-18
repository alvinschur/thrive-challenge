# frozen_string_literal: true

# User stores data related to a single user.  Currently implemented
# using ruby's `Data` clas to gain some immutability.
#
# This could be implemented using `ActiveModel`` to gain improved data validation.
class User < Data.define(:id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens)
  INTEGER_FIELDS = %i[id company_id tokens].freeze
  STRING_FIELDS = %i[first_name last_name email].freeze
  BOOLEAN_FIELDS = %i[email_status active_status].freeze

  def valid?
    return false unless field_classes(STRING_FIELDS) == [String]
    return false unless field_classes(INTEGER_FIELDS) == [Integer]
    return false unless (field_classes(BOOLEAN_FIELDS) - [TrueClass, FalseClass]).empty?
    return false if tokens.negative?

    true
  end

  private

  def field_classes(fields)
    fields.map(&method(:public_send)).map(&:class).uniq
  end
end
