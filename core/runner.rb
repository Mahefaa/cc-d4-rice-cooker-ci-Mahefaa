# frozen_string_literal: true

require_relative '../utils/logger_utils'
require_relative 'rice_cooker'

# Runner is an app runner defining which classes to run, showing the choices, it is like an interactive cli
class Runner
  attr_reader :cooker

  def initialize(cooker)
    @cooker = cooker
    @is_running = false
  end

  def run
    @is_running = true

    show_menu

    print('')
    answer = $stdin.gets.chomp
    handle_input(answer)
  end

  def stop
    @is_running = false
    Process.exit(0)
  end

  MENU_MESSAGE = " Cooker Menu:
          1. plug a rice cooker in
          2. unplug a rice cooker
          3. increase rice amount by 1 cup
          4. increase water level by 1L
          5. decrease rice amount by 1 cup
          6. decrease water level by 1L
          7. cook rice (needs water)
          8. boil water (does not need rice)
          0. Exit
          Enter your choice:"

  def show_menu
    show_state
    LoggerUtils.log_info <<~MENU
      #{MENU_MESSAGE}
    MENU
  end

  def show_state
    LoggerUtils.log_info <<~STATE
      Cooker:
        state: #{@cooker.status[:power_status]}, #{@cooker.status[:work_status]}
        rice level: #{@cooker.rice_amount},
        water level: #{@cooker.water_level},
        available space: #{@cooker.compute_available_space}
    STATE
  end

  def handle_input(answer)
    LoggerUtils.try_catch_logger(
      proc do
        number = Integer(answer)
        raise CustomError, 'unknown Argument, try again' if number.nil? || number.to_s != answer

        handle_choice(number)
      end,
      proc {}
    )
  end

  CHOICE_ACTIONS = {
    1 => :plug,
    2 => :unplug,
    3 => :add_rice,
    4 => :add_water,
    5 => :decrease_rice_amount,
    6 => :decrease_water_level,
    7 => :cook,
    8 => :boil_water,
    0 => :stop
  }.freeze

  def handle_choice(choice)
    action = CHOICE_ACTIONS[choice]
    raise ArgumentError, 'Invalid choice' unless action

    finally_continued_try_catch_logger { send(action) }
  end

  def plug
    @cooker.plug
  end

  def unplug
    @cooker.unplug
  end

  def add_rice
    @cooker.add_rice
  end

  def add_water
    @cooker.add_water
  end

  def decrease_rice_amount
    @cooker.decrease_rice_amount
  end

  def decrease_water_level
    @cooker.decrease_water_level
  end

  def cook
    @cooker.cook
  end

  def boil_water
    @cooker.boil_water
  end
end

def continue
  if @is_running
    run
  else
    LoggerUtils.log_info('Application closed')
    @is_running = false
    Process.exit(0)
  end
end

def finally_continued_try_catch_logger(&try_cb)
  LoggerUtils.try_catch_logger(try_cb, method(:continue))
end
