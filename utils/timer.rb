# frozen_string_literal: true

require_relative 'logger_utils'

# Timer module is a module which makes the program wait, like a regular timer.
# current implementation simply logs an iteration
module Timer
  def self.count_from_one_until(time)
    (1..time).each { |i| LoggerUtils.log_info(i) }
  end
end
