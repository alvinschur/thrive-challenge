# frozen_string_literal: true

Dir[File.join(__dir__, 'challenge', '*.rb')].each do |file|
  require file
end
