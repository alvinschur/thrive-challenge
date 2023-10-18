# frozen_string_literal: true

# TokenUpdateFormatter writes the results of topping up tokens to
# an IO stream.  A future enhancement is to use a minimalist templating
# solution.
class TokenUpdateFormatter
  attr_reader :token_update_summary, :io

  def initialize(token_update_summary, io: $stdout)
    @token_update_summary = token_update_summary
    @io = io
  end

  def write
    io.puts ''
    token_update_summary.sort { |a, b| a.company.id <=> b.company.id }.each do |summary|
      company_summary(summary)
    end
  end

  private

  def company_summary(summary)
    io.puts  "\tCompany Id: #{summary.company.id}"
    io.puts  "\tCompany Name: #{summary.company&.name}"

    email_summary(summary)

    io.puts  "\t\tTotal amount of top ups for #{summary.company.name}: #{summary.total_top_ups}"
    io.puts  ''
  end

  def email_summary(summary)
    io.puts "\tUsers Emailed:"
    summary.emails_sent.each { |update| io.puts email_details(update) }

    io.puts "\tUsers Not Emailed:"
    summary.emails_not_sent.each { |update| io.puts email_details(update) }
  end

  def email_details(update)
    <<~EMAIL
      \t\t#{update.user.last_name}, #{update.user.first_name}, #{update.user.email}
      \t\t  Previous Token Balance, #{update.tokens_before}
      \t\t  New Token Balance #{update.tokens_after}
    EMAIL
  end
end
