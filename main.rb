# frozen_string_literal: true

require_relative 'core/runner'
require_relative 'core/rice_cooker'

rice_cooker = RiceCooker.new
runner = Runner.new(rice_cooker)

runner.run
