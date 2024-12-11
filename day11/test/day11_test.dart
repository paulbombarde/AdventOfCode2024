import 'package:day11/day11.dart';
import 'package:test/test.dart';

void main() {
  test('stone change', () {
    expect(stoneChange(0), [1]);

    expect(stoneChange(10), [1, 0]);
    expect(stoneChange(12), [1, 2]);
    expect(stoneChange(1000), [10, 0]);
    expect(stoneChange(1020), [10, 20]);

    expect(stoneChange(1), [2024]);
    expect(stoneChange(100), [202400]);
    expect(stoneChange(123), [248952]);
  });

  test('stone count from single stone', (){
    expect(stonesCountFromStone(12345, 0), 1);

    expect(stonesCountFromStone(0, 1), 1);
    expect(stonesCountFromStone(1, 1), 1);
    expect(stonesCountFromStone(2024, 1), 2);
    expect(stonesCountFromStone(20, 1), 2);
    expect(stonesCountFromStone(24, 1), 2);

    expect(stonesCountFromStone(0, 2), 1);
    expect(stonesCountFromStone(1, 2), 2);
    expect(stonesCountFromStone(2024, 2), 4);
  });

  test('stone count from stones', (){
    expect(stonesCountFromStones([0, 1, 10, 99, 999], 1), 7);

    expect(stonesCountFromStones([125, 17], 1), 3);
    expect(stonesCountFromStones([125, 17], 2), 4);
    expect(stonesCountFromStones([125, 17], 3), 5);
    expect(stonesCountFromStones([125, 17], 4), 9);
    expect(stonesCountFromStones([125, 17], 5), 13);
    expect(stonesCountFromStones([125, 17], 6), 22);
    expect(stonesCountFromStones([125, 17], 25), 55312);
  });
}
