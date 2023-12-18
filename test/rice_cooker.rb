require 'minitest/autorun'
require_relative '../core/rice_cooker'

class Test < Minitest::Test
  def test_add_water_ok()
    cooker = RiceCooker.new

    cooker.add_water

    assert(1 == cooker.water_level)
  end

  def test_decrease_water_level_ok
    cooker = RiceCooker.new

    cooker.add_water
    cooker.decrease_water_level

    assert(0 == cooker.water_level)
  end

  def test_add_rice_ok
    cooker = RiceCooker.new

    cooker.add_rice

    assert(1 == cooker.rice_amount)
  end

  def test_decrease_rice_amount_ok
    cooker = RiceCooker.new

    cooker.add_rice
    cooker.decrease_rice_amount

    assert(0 == cooker.rice_amount)
  end

end