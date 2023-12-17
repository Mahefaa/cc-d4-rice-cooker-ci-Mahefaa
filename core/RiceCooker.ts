import CustomError from './error/CustomError'
import countFromOneUntil from '../utils/timer'
import { log } from '../utils/loggerUtils'

class RiceCooker {
  private readonly _status: status
  private readonly _max_space: number
  private _water_level: number
  private _rice_amount: number

  private readonly DEFAULT_MAX_SPACE = 10

  constructor () {
    this._max_space = this.DEFAULT_MAX_SPACE
    this._status = { power_status: POWER_STATUS.OFF, work_status: WORK_STATUS.AVAILABLE }
    this._water_level = 0
    this._rice_amount = 0
    this._status = { power_status: POWER_STATUS.OFF, work_status: WORK_STATUS.AVAILABLE }
  }

  get status (): status {
    return this._status
  }

  get water_level (): number {
    return this._water_level
  }

  get rice_amount (): number {
    return this._rice_amount
  }

  compute_available_space (): number {
    return this._max_space - this._water_level - this._rice_amount
  }

  add_water (): number {
    this.ensure_capacity()
    log.info('adding 1L of water')
    return this.water_actions.increase_amount()
  }

  add_rice (): number {
    this.ensure_capacity()
    log.info('adding 1 cup of rice')
    return this._rice_amount++
  }

  decrease_water_level (): number {
    if (this._water_level > 0) {
      return this._water_level--
    }
    throw new CustomError('Water level is already 0')
  }

  decrease_rice_amount (): number {
    if (this._rice_amount > 0) {
      log.info('removing 1 cup of rice')
      return this._rice_amount--
    }
    throw new CustomError('Water level is already 0')
  }

  private ensure_capacity (): void {
    const availableSpace = this.compute_available_space()
    if (availableSpace === 0) {
      throw new CustomError('Rice cooker is already full.')
    }
  }

  plug (): this {
    if (this.isPluggedIn()) {
      throw new CustomError('rice cooker already plugged in')
    }
    log.info('plugging the rice cooker in')
    this._status.power_status = POWER_STATUS.ON
    log.info('rice cooker plugged in')
    return this
  }

  private isPluggedIn (): boolean {
    return this._status.power_status === POWER_STATUS.ON
  }

  private isBusy (): boolean {
    return this._status.work_status === WORK_STATUS.BUSY
  }

  unplug (): this {
    if (!this.isPluggedIn()) {
      throw new CustomError('rice cooker already unplugged')
    }
    log.info('unplugging the rice cooker')
    this._status.power_status = POWER_STATUS.OFF
    log.info('rice cooker plugged out')
    return this
  }

  private readonly RICE_COOKER_COOKING_TIME = 10

  cook (): void {
    this.ensureAvailability()
    this.ensureWaterPresence()
    log.info('cooking')
    this._status.work_status = WORK_STATUS.BUSY
    countFromOneUntil(this.RICE_COOKER_COOKING_TIME)
    this._status.work_status = WORK_STATUS.AVAILABLE
  }

  private ensureWaterPresence (): void {
    if (this._water_level <= 0) {
      throw new CustomError('Rice Cooker needs water')
    }
  }

  private ensureRicePresence (): void {
    if (this._rice_amount <= 0) {
      throw new CustomError('Rice Cooker needs rice for this action')
    }
  }

  private ensureAvailability (): void {
    if (this.isPluggedIn()) {
      throw new CustomError('Turn the rice cooker on first')
    }
    if (this.isBusy()) {
      throw new CustomError('Wait for the rice cooker to be free')
    }
  }

  boil_water (): this {
    this.ensureAvailability()
    log.info('boiling water')
    this._status.work_status = WORK_STATUS.BUSY
    countFromOneUntil(8)
    this._status.work_status = WORK_STATUS.AVAILABLE
    return this
  }

  private readonly water_actions: leveled = {
    increase_amount: () => {
      return this._water_level++
    },
    decrease_amount: () => {
      return this._water_level--
    }
  }

  private readonly rice_actions: leveled = {
    increase_amount: () => {
      return this._rice_amount++
    },
    decrease_amount: () => {
      return this._rice_amount--
    }
  }
}

interface status {
  power_status: POWER_STATUS
  work_status: WORK_STATUS
}

enum POWER_STATUS {
  ON = 'ON',
  OFF = 'OFF'
}

enum WORK_STATUS {
  BUSY = 'BUSY',
  AVAILABLE = 'AVAILABLE'
}

interface leveled {
  decrease_amount: () => number

  increase_amount: () => number
}

export { RiceCooker, POWER_STATUS, WORK_STATUS }
