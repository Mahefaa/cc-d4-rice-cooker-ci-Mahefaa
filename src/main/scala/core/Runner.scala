package core

import core.exception.CustomException

import scala.io.StdIn

class Runner(cooker: RiceCooker) {
  private var isRunning: Boolean = false

  def run(): Unit = {
    isRunning = true

    showMenu()

    val choice = StdIn.readInt()
    tryCatchLogger(
      () => {
        handleChoice(choice)
      },
      () => {}
    )
  }

  def stop(): Unit = {
    isRunning = false
    System.exit(0)
  }

  def showMenu(): Unit = {
    showState()
    println(
      """
        |Cooker Menu:
        |1. Plug a rice cooker in
        |2. Unplug a rice cooker
        |3. Increase rice amount by 1 cup
        |4. Increase water level by 1L
        |5. Decrease rice amount by 1 cup
        |6. Decrease water level by 1L
        |7. Cook rice (needs water)
        |8. Boil water (does not need rice)
        |0. Exit
        |Enter your choice:""".stripMargin
    )
  }

  def showState(): Unit = {
    logInfo(
      s"""
         |Cooker:
         |state: ${cooker.getStatus.powerStatus}, ${cooker.getStatus.workStatus}
         |rice level: ${cooker.getRiceAmount}
         |water level: ${cooker.getWaterLevel}
         |available space: ${cooker.computeAvailableSpace}
         |""".stripMargin
    )
  }

  def handleChoice(choice: Int): Unit = {
    choice match {
      case 1 => finallyContinuedTryCatchLogger(() => cooker.plug())
      case 2 => finallyContinuedTryCatchLogger(() => cooker.unplug())
      case 3 => finallyContinuedTryCatchLogger(() => cooker.addRice())
      case 4 => finallyContinuedTryCatchLogger(() => cooker.addWater())
      case 5 => finallyContinuedTryCatchLogger(() => cooker.decreaseRiceAmount())
      case 6 => finallyContinuedTryCatchLogger(() => cooker.decreaseWaterLevel())
      case 7 => finallyContinuedTryCatchLogger(() => cooker.cook())
      case 8 => finallyContinuedTryCatchLogger(() => cooker.boilWater())
      case 0 => stop()
      case _ => logError("Unknown choice, try again")
    }
    continue()
  }

  def continue(): Unit = {
    if (isRunning) {
      run()
    } else {
      logInfo("Rice cooker application closed")
      isRunning = false
      System.exit(0)
    }
  }

  private def finallyContinuedTryCatchLogger(tryCb: () => Unit): Unit = {
    tryCatchLogger(
      tryCb,
      () => continue()
    )
  }

  private def tryCatchLogger(tryCb: () => Unit, finallyCb: () => Unit): Unit = {
    try {
      tryCb()
    } catch {
      case customException: CustomException =>
        logError(customException.getMessage)
      case _: Throwable =>
        logError("An unexpected error occurred")
    } finally {
      finallyCb()
    }
  }

  private def logInfo(message: Any): Unit = {
    System.out.println(s"Info: $message")
  }

  private def logError(message: Any): Unit = {
    System.err.println(s"Error: $message")
  }
}
