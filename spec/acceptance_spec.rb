# frozen_string_literal: true

# require_relative '../../challenge'

RSpec.describe 'challenge.rb cli' do
  let(:challenge_cli) { File.join(__dir__, '..', 'challenge.rb') }

  let(:companies_filename) { data_path_to(folder:, file: 'companies.json') }
  let(:users_filename) { data_path_to(folder:, file: 'users.json') }
  let(:expected_output) { File.read(data_path_to(folder:, file: 'example_output.txt')) }

  context 'with sample data' do
    let(:folder) { 'sample' }

    it 'works with the sample input and output' do
      run_in_data_folder(folder:) do
        `#{challenge_cli} #{companies_filename} #{users_filename}`
        actual_output = File.read(default_output_filename)
        expect(actual_output).to eq(expected_output)
      end
    end
  end

  context 'with invalid company data' do
    let(:folder) { 'invalid_company' }

    it 'displays the invalid company record' do
      run_in_data_folder(folder:) do
        output = `#{challenge_cli} #{companies_filename} #{users_filename}`
        expect(output).to include('Invalid records')
        expect(output).to include('data Company id=1, name="Blue Cat Inc.", top_up="34", email_status=false')
      end
    end
  end

  context 'with invalid user data' do
    let(:folder) { 'invalid_user' }

    it 'displays the invalid user record' do
      run_in_data_folder(folder:) do
        output = `#{challenge_cli} #{companies_filename} #{users_filename}`
        expect(output).to include('Invalid records')
        expect(output).to include('email_status=false, active_status=true, tokens="oops"')
      end
    end
  end
end
