# frozen_string_literal: true

# UserFactory creates a User instance from a hash of data.
# Possible features include
# - add default values if needed
# - add additional data validation / error detection
class UserFactory
  def create(data)
    User.new(**data)
  end

  def invalid_null_object
    User.new(id: 0, name: '', top_up: 0, email_status: false)
  end
end
