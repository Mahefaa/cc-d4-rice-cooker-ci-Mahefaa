# frozen_string_literal: true

require_relative 'error/error'
require_relative '../utils/logger_utils'
require_relative '../utils/timer'

# Rice cooker is a kitchen appliance used to cook rice or boil water.
class RiceCooker
  POWER_STATUS = { ON: 'ON', OFF: 'OFF' }.freeze
  WORK_STATUS = { BUSY: 'BUSY', AVAILABLE: 'AVAILABLE' }.freeze

  attr_reader :status, :water_level, :rice_amount

  def initialize
    @max_space = 10
    @default_max_space = 10
    @status = { power_status: POWER_STATUS[:OFF], work_status: WORK_STATUS[:AVAILABLE] }
    @water_level = 0
    @rice_amount = 0
  end

  def compute_available_space
    @max_space - @water_level - @rice_amount
  end

  def add_water
    ensure_capacity
    LoggerUtils.log_info('adding 1L of water')
    water_actions[:increase_amount].call
  end

  def add_rice
    ensure_capacity
    LoggerUtils.log_info('adding 1 cup of rice')
    @rice_amount += 1
  end

  def decrease_water_level
    raise CustomError, 'Water level is already 0' unless @water_level.positive?

    @water_level -= 1
  end

  def decrease_rice_amount
    raise CustomError, 'Rice amount is already 0' unless @rice_amount.positive?

    LoggerUtils.log_info('removing 1 cup of rice')
    @rice_amount -= 1
  end

  def plug
    raise CustomError, 'Rice cooker already plugged in' if plugged_in?

    LoggerUtils.log_info('plugging the rice cooker in')
    @status[:power_status] = POWER_STATUS[:ON]
    LoggerUtils.log_info('rice cooker plugged in')
    self
  end

  def unplug
    raise CustomError, 'Rice cooker already unplugged' unless plugged_in?

    LoggerUtils.log_info('unplugging the rice cooker')
    @status[:power_status] = POWER_STATUS[:OFF]
    LoggerUtils.log_info('rice cooker plugged out')
    self
  end

  def cook
    ensure_availability
    ensure_water_presence
    ensure_rice_presence
    LoggerUtils.log_info('cooking')
    @status[:work_status] = WORK_STATUS[:BUSY]
    Timer.count_from_one_until(10)
    LoggerUtils.log_info('rice is cooked')
    @status[:work_status] = WORK_STATUS[:AVAILABLE]
  end

  def boil_water
    ensure_availability
    ensure_water_presence
    LoggerUtils.log_info('boiling water')
    @status[:work_status] = WORK_STATUS[:BUSY]
    Timer.count_from_one_until(8)
    LoggerUtils.log_info('water is boiling')
    @status[:work_status] = WORK_STATUS[:AVAILABLE]
    self
  end

  private

  def ensure_capacity
    available_space = compute_available_space
    raise CustomError, 'Rice cooker is already full.' if available_space.zero?
  end

  def plugged_in?
    @status[:power_status] == POWER_STATUS[:ON]
  end

  def busy?
    @status[:work_status] == WORK_STATUS[:BUSY]
  end

  def ensure_availability
    raise CustomError, 'Turn the rice cooker on first' unless plugged_in?
    raise CustomError, 'Wait for the rice cooker to be free' if busy?
  end

  def ensure_water_presence
    raise CustomError, 'Rice Cooker needs water' if @water_level <= 0
  end

  def ensure_rice_presence
    raise CustomError, 'Rice Cooker needs rice for this action' if @rice_amount <= 0
  end

  def water_actions
    {
      increase_amount: -> { @water_level += 1 },
      decrease_amount: -> { @water_level -= 1 }
    }
  end

  def rice_actions
    {
      increase_amount: -> { @rice_amount += 1 },
      decrease_amount: -> { @rice_amount -= 1 }
    }
  end
end
