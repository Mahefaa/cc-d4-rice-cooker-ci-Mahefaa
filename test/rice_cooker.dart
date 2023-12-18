import 'package:test/test.dart';
import '../core/rice_cooker.dart';

void main() {
  group('RiceCooker add test', () {
    test('add water ok', () {
      var rice_cooker = RiceCooker();

      rice_cooker.addWater();

      expect(1, rice_cooker.waterLevel);
    });

    test('decrease water amount ok', () {
      var rice_cooker = RiceCooker();
      rice_cooker.addWater();

       rice_cooker.decreaseWaterLevel();

      expect(0, rice_cooker.waterLevel);
    });

    test('add rice ok', () {
      var rice_cooker = RiceCooker();

      rice_cooker.addRice();

      expect(1, rice_cooker.riceAmount);
    });

    test('decrease rice amount ok', () {
     var rice_cooker = RiceCooker();
     rice_cooker.addRice();

     rice_cooker.decreaseRiceAmount();

      expect(0, rice_cooker.riceAmount);
    });
  });
}