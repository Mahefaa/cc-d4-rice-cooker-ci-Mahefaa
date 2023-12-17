import tryCatchLogger, { log } from '../utils/loggerUtils'
import { type RiceCooker } from './RiceCooker'
import readline from 'readline'
import process from 'process'

export default class Runner {
  private readonly cooker: RiceCooker
  private readonly userInputReader
  private isRunning: boolean

  constructor (cooker: RiceCooker) {
    this.cooker = cooker
    this.userInputReader = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    })
    this.isRunning = false
  }

  run (): void {
    this.isRunning = true

    this.showMenu()

    this.userInputReader.question('', (answer: string) => {
      tryCatchLogger(() => {
        const number = parseInt(answer)
        if (isNaN(number)) {
          log.error('unknown Argument, try again')
          return
        }
        this.handleChoice(number)
      }, () => {
      })
    })
  }

  stop (): void {
    this.isRunning = false
    process.exit(0)
  }

  showMenu (): void {
    this.showState()
    console.log(`
            Cooker Menu:
                    1. plug a rice cooker in
                    2. unplug a rice cooker
                    3. increase rice amount by 1cup
                    4. increase water level by 1L
                    5. decrease rice amount by 1cup
                    6. decrease water level by 1L
                    7. cook rice (needs water)
                    8. boil water ( does not need rice)
                    0. Exit
                    Enter your choice:
        `)
  }

  showState: () => void = () => {
    log.info(`
      Cooker : 
        state : ${this.cooker.status.power_status}, ${this.cooker.status.work_status}
        rice level : ${this.cooker.rice_amount},
        water level : ${this.cooker.water_level},
        available space : ${this.cooker.compute_available_space()}
    `)
  }

  handleChoice: (choice: number) => void = (choice: number) => {
    switch (choice) {
      case 1: {
        this.finallyContinuedTryCatchLogger(() => {
          this.cooker.plug()
        })
        break
      }
      case 2 : {
        this.finallyContinuedTryCatchLogger(() => {
          this.cooker.unplug()
        })
        break
      }

      case 3 : {
        this.finallyContinuedTryCatchLogger(() => {
          this.cooker.add_rice()
        })
        break
      }

      case 4 : {
        this.finallyContinuedTryCatchLogger(() => {
          this.cooker.add_water()
        })
        break
      }

      case 5 : {
        this.finallyContinuedTryCatchLogger(() => {
          this.cooker.decrease_rice_amount()
        })
        break
      }
      case 6: {
        this.finallyContinuedTryCatchLogger(() => {
          this.cooker.decrease_water_level()
        })
        break
      }
      case 7 : {
        this.finallyContinuedTryCatchLogger(() => {
          this.cooker.cook()
        })
        break
      }
      case 8 : {
        this.finallyContinuedTryCatchLogger(() => {
          this.cooker.boil_water()
        })
        break
      }
      case 0: {
        this.stop()
        break
      }
    }
  }

  continue (): void {
    if (this.isRunning) {
      this.run()
    } else {
      log.info('Wallet application closed')
      this.isRunning = false
      process.exit(0)
    }
  }

  private readonly finallyContinuedTryCatchLogger: (tryCb: () => unknown) => void = (tryCb: () => unknown) => {
    tryCatchLogger(tryCb, () => {
      this.continue()
    })
  }
}
