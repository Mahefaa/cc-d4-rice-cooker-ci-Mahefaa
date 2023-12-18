import 'core/rice_cooker.dart';
import 'core/runner.dart';

void main() {
  final riceCooker = RiceCooker();
  final runner = Runner(riceCooker);

  runner.run();
}