import CustomError from '../core/error/CustomError'

export default function tryCatchLogger (tryCb: () => unknown, finallyCb: () => void): unknown {
  try {
    return tryCb()
  } catch (error) {
    if (error instanceof CustomError) {
      log.error(error.message)
    } else {
      throw error
    }
  } finally {
    finallyCb()
  }
}
export const log = {
  info: (message: any) => {
    console.log(`Info : ${message}`)
  },
  error: (message: any) => {
    console.error(`Error : ${message}`)
  }
}
