# frozen_string_literal: true

# CompanyFactory creates a Company instance from a hash of data.
# Possible features include
# - add default values if needed
# - add additional data validation / error detection
class CompanyFactory
  def create(data)
    Company.new(**data)
  end

  def invalid_null_object
    Company.new(id: 0, name: '', top_up: 0, email_status: false)
  end
end
