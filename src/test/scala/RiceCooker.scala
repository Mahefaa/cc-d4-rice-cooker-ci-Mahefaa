import core.RiceCooker
import org.scalatest.funspec.AnyFunSpec
import org.scalatest.matchers.should.Matchers

class RiceCookerTest extends AnyFunSpec with Matchers {
  describe("rice cooker value add and remove test") {

    it("add water ok") {
      val riceCooker = new RiceCooker()

      riceCooker.addWater()

      riceCooker.getWaterLevel shouldEqual 1
    }

    it("decrease water level ok") {
      val riceCooker = new RiceCooker()
      riceCooker.addWater()

      riceCooker.decreaseWaterLevel()

      riceCooker.getWaterLevel shouldEqual 0
    }
    it("add rice ok") {
      val riceCooker = new RiceCooker()

      riceCooker.addRice()

      riceCooker.getRiceAmount shouldEqual 1
    }
    it("decrease rice amount") {
      val riceCooker = new RiceCooker()
      riceCooker.addRice()

      riceCooker.decreaseRiceAmount()

      riceCooker.getWaterLevel shouldEqual 0
    }
  }
}
