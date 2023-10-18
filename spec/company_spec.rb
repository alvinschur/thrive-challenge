# frozen_string_literal: true

require_relative '../challenge'

RSpec.describe Company do
  let(:valid_data) do
    {
      id: 5, name: 'LMN', top_up: 3, email_status: false
    }
  end

  context 'with valid data' do
    it '#valid? is true' do
      expect(Company.new(**valid_data)).to be_valid
    end
  end

  context 'with invalid data' do
    it '#valid? is false when top_up is not an integer' do
      data = valid_data.merge(top_up: 'ab')
      expect(Company.new(**data)).not_to be_valid
    end

    it '#valid? is false when top_up is negative' do
      data = valid_data.merge(top_up: -1)
      expect(Company.new(**data)).not_to be_valid
    end

    it '#valid? is false when name is not a string' do
      data = valid_data.merge(name: 32)
      expect(Company.new(**data)).not_to be_valid
    end

    it '#valid? is false when email_status is not a boolean' do
      data = valid_data.merge(email_status: 32)
      expect(Company.new(**data)).not_to be_valid
    end
  end
end
