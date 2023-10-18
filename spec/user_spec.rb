# frozen_string_literal: true

require_relative '../challenge'

RSpec.describe User do
  let(:valid_data) do
    {
      id: 1, first_name: 'ABC', last_name: 'XYZ', email: 'sample@example.com', company_id: 2,
      email_status: true, active_status: true, tokens: 3
    }
  end

  context 'with valid data' do
    it '#valid? is true' do
      expect(User.new(**valid_data)).to be_valid
    end
  end

  context 'with invalid data' do
    it '#valid? is false when tokens is not an integer' do
      data = valid_data.merge(tokens: 'ab')
      expect(User.new(**data)).not_to be_valid
    end

    it '#valid? is false when tokens is not present' do
      data = valid_data.merge(tokens: nil)
      expect(User.new(**data)).not_to be_valid
    end

    it '#valid? is false when tokens is negative' do
      data = valid_data.merge(tokens: -1)
      expect(User.new(**data)).not_to be_valid
    end

    it '#valid? is false when first_name is not a string' do
      data = valid_data.merge(first_name: 32)
      expect(User.new(**data)).not_to be_valid
    end

    it '#valid? is false when active_status is not a boolean' do
      data = valid_data.merge(active_status: 32)
      expect(User.new(**data)).not_to be_valid
    end
  end
end
