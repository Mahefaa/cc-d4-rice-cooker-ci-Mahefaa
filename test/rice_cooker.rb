require 'minitest/autorun'

class Test < Minitest::Test
  def add_water_ok()
    cooker = RiceCooker.new

    cooker.add_water

    assert(1 == cooker.water_level)
  end

  def decrease_water_level_ok
    cooker = RiceCooker.new

    cooker.add_water
    cooker.decrease_water_level

    assert(0 == cooker.water_level)
  end

  def add_rice_ok
    cooker = RiceCooker.new

    cooker.add_rice

    assert(1 == cooker.rice_amount)
  end

  def decrease_rice_amout_ok
    cooker = RiceCooker.new

    cooker.add_rice
    cooker.decrease_water_level

    assert(0 == cooker.rice_amount)
  end

end