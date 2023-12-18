package core

import core.exception.CustomException

case class Status(powerStatus: PowerStatus.Value, workStatus: WorkStatus.Value)

object PowerStatus extends Enumeration {
  val ON, OFF = Value
}

object WorkStatus extends Enumeration {
  val BUSY, AVAILABLE = Value
}

trait Leveled {
  def increaseAmount(): Int

  def decreaseAmount(): Int
}

object RiceCooker {
  val DEFAULT_MAX_SPACE: Int = 10
}

class RiceCooker {
  private var status: Status = Status(powerStatus = PowerStatus.OFF, workStatus = WorkStatus.AVAILABLE)
  private val maxSpace: Int = RiceCooker.DEFAULT_MAX_SPACE
  private var waterLevel: Int = 0
  private var riceAmount: Int = 0

  def getStatus: Status = status

  def getWaterLevel: Int = waterLevel

  def getRiceAmount: Int = riceAmount

  def computeAvailableSpace: Int = maxSpace - waterLevel - riceAmount

  def addWater(): Int = {
    ensureCapacity()
    println("Adding 1L of water")
    waterActions.increaseAmount()
  }

  def addRice(): Int = {
    ensureCapacity()
    println("Adding 1 cup of rice")
    riceAmount += 1
    riceAmount
  }

  def decreaseWaterLevel(): Int = {
    if (waterLevel > 0) {
      waterLevel -= 1
      waterLevel
    } else {
      throw new CustomException("Water level is already 0")
    }
  }

  def decreaseRiceAmount(): Int = {
    if (riceAmount > 0) {
      println("Removing 1 cup of rice")
      riceAmount -= 1
      riceAmount
    } else {
      throw new CustomException("Rice amount is already 0")
    }
  }

  private def ensureCapacity(): Unit = {
    val availableSpace = computeAvailableSpace
    if (availableSpace == 0) {
      throw new CustomException("Rice cooker is already full.")
    }
  }

  def plug(): RiceCooker = {
    if (isPluggedIn) {
      throw new CustomException("rice cooker already plugged in")
    }
    this.status = status.copy(powerStatus = PowerStatus.ON);
    this
  }

  def unplug(): RiceCooker = {
    if (!isPluggedIn) {
      throw new CustomException("rice cooker already unplugged")
    }
    this.status = status.copy(powerStatus = PowerStatus.OFF);
    this
  }

  private val RICE_COOKER_COOKING_TIME: Int = 10

  def cook(): Unit = {
    ensureAvailability()
    ensureWaterPresence()
    ensureRicePresence()
    println("Cooking")
    status = status.copy(workStatus = WorkStatus.BUSY)
    countFromOneUntil(RICE_COOKER_COOKING_TIME)
    status = status.copy(workStatus = WorkStatus.AVAILABLE)
  }

  private def ensureWaterPresence(): Unit = {
    if (waterLevel <= 0) {
      throw new CustomException("Rice Cooker needs water")
    }
  }

  private def ensureRicePresence(): Unit = {
    if (riceAmount <= 0) {
      throw new CustomException("Rice Cooker needs water")
    }
  }
  private def ensureAvailability(): Unit = {
    if (!isPluggedIn) {
      throw new CustomException("Turn the rice cooker on first")
    }
    if (isBusy) {
      throw new CustomException("Wait for the rice cooker to be free")
    }
  }

  private def isPluggedIn: Boolean = status.powerStatus == PowerStatus.ON

  private def isBusy: Boolean = status.workStatus == WorkStatus.BUSY

  def boilWater(): Unit = {
    ensureAvailability()
    ensureWaterPresence()
    println("Boiling water")
    status = status.copy(workStatus = WorkStatus.BUSY)
    countFromOneUntil(8)
    status = status.copy(workStatus = WorkStatus.AVAILABLE)
  }

  private def waterActions: Leveled = new Leveled {
    def increaseAmount(): Int = {
      waterLevel += 1
      waterLevel
    }

    def decreaseAmount(): Int = {
      waterLevel -= 1
      waterLevel
    }
  }

  private def countFromOneUntil(maxNumberInclusive: Int): Unit = {
    for (i <- 0 to maxNumberInclusive) {
      println(i);
    }
  }
}
