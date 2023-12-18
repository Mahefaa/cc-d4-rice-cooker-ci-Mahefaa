import core.{RiceCooker, Runner}

object Main extends App {
  val riceCooker = new RiceCooker()
  val runner = new Runner(riceCooker)
  runner.run()
}
