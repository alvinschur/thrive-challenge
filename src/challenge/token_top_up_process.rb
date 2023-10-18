# frozen_string_literal: true

# TokenTopUpProcess calculates a new token balance for active
# users and identifies which users to notify (send emails).
#
# This class does a bit too much.  Extracting `#input_data` to
# another class improves reuse.  In particular, as more data is
# loaded from a file, the new `InputData` class could combine
# multiple data types (User, Company, Course, etc).
#
# Spoiler alert: some production systems won't need this extra
# class.  ActiveRecord does the work for us.
class TokenTopUpProcess
  attr_reader :companies, :users

  # InputData collects all necessary input data for this business process.
  InputData = Data.define(:company, :users)

  # TokenUpdate stores results of the business calculation for one user.
  TokenUpdate = Data.define(:user, :tokens_before, :tokens_after, :notify_user)

  # TokenUpdateSummary collects all results of the business calculation in one place.
  class TokenUpdateSummary < Data.define(:company, :users, :token_updates)
    def emails_sent
      token_updates.select(&:notify_user).sort { |a, b| a.user.last_name <=> b.user.last_name }
    end

    def emails_not_sent
      token_updates.reject(&:notify_user).sort { |a, b| a.user.last_name <=> b.user.last_name }
    end

    def total_top_ups
      token_updates.sum { |update| update.tokens_after - update.tokens_before }
    end
  end

  def initialize(companies:, users:)
    @companies = companies
    @users = users
  end

  def process
    input_data
    calculate_token_top_up
  end

  def input_data
    users_by_company_id = group_users_by_company_id
    companies_by_company_id = companies.group_by(&:id)
    company_ids = companies.map(&:id).uniq
    all_company_ids = (users_by_company_id.keys & company_ids).sort
    @token_top_up_input_data =
      all_company_ids.map do |company_id|
        i = InputData.new(company: companies_by_company_id[company_id].first,
                          users: users_by_company_id[company_id] || [])
        i
      end
  end

  def calculate_token_top_up
    @token_top_up_input_data.map(&method(:top_up_tokens))
  end

  def top_up_tokens(input_data)
    token_updates = input_data.users.select(&:active_status).map do |user|
      TokenUpdate.new(
        user:,
        tokens_before: user.tokens,
        tokens_after: user.tokens + input_data.company.top_up,
        notify_user: user.email_status && input_data.company.email_status
      )
    end
    TokenUpdateSummary.new(input_data.company, input_data.users, token_updates)
  end

  def group_users_by_company_id
    users.group_by(&:company_id)
  end
end
