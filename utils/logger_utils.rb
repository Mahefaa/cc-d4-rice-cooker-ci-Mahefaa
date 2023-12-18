# frozen_string_literal: true

require_relative '../core/error/error'

# Logger module for console showing and try rescuing
module LoggerUtils
  def self.try_catch_logger(try_cb, finally_cb)
    try_cb.call
  rescue CustomError => e
    log_error(e.message)
  else
    # No error occurred
  ensure
    finally_cb.call
  end

  def self.log_info(message)
    puts "Info: #{message}"
  end

  def self.log_error(message)
    puts "Error: #{message}"
  end
end
