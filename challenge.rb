#!/usr/bin/env ruby

require_relative 'src/challenge'

class ChallengeCli
  def self.print_usage_and_exit
    puts "Usage: #{$PROGRAM_NAME} companies.json users.json"
    puts 'Output is in output.txt'
    exit 1
  end

  def self.start(args)
    print_usage_and_exit unless args.length == 2
    companies = args[0]
    users = args[1]

    ChallengeCli.new(companies:, users:).top_up_tokens
  end

  def initialize(companies:, users:, output: 'output.txt')
    @companies = companies
    @users = users
    @output = output
  end

  def top_up_tokens
    puts "Loading companies from #{@companies.inspect} and users from #{@users.inspect}"
    puts "Writing output to #{@output.inspect}"

    company_loader = DataLoader.load_or_exit_on_error(CompanyFactory.new, @companies)
    user_loader = DataLoader.load_or_exit_on_error(UserFactory.new, @users)

    token_update_summary = TokenTopUpProcess.new(companies: company_loader.valid_data,
                                                 users: user_loader.valid_data).process

    File.open(@output, 'wb') { |file| TokenUpdateFormatter.new(token_update_summary, io: file).write }

    puts 'All done.'
  end
end

ChallengeCli.start(ARGV) if __FILE__ == $PROGRAM_NAME
