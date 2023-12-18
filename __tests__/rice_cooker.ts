import '@jest/globals'
import { describe } from 'node:test'
import { RiceCooker } from '../core/RiceCooker'

void describe('Test rice cooker', () => {
  test('add_water ok', () => {
    const cooker = new RiceCooker()
    expect(cooker.water_level === 0)

    cooker.add_water()
    expect(cooker.water_level === 1)
  })
  test('decrease_water_level ok', () => {
    const cooker = new RiceCooker()
    expect(cooker.water_level === 0)

    cooker.add_water()
    cooker.decrease_water_level()

    expect(cooker.water_level === 0)
  })
  test('add_rice ok', () => {
    const cooker = new RiceCooker()
    expect(cooker.rice_amount === 0)

    cooker.add_rice()

    expect(cooker.rice_amount === 1)
  })
  test('decrease_rice_amount ok', () => {
    const cooker = new RiceCooker()

    cooker.add_rice()
    cooker.decrease_rice_amount()

    expect(cooker.rice_amount === 0)
  })
})
