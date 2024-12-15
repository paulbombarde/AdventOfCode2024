import 'package:day13/day13.dart';
import 'package:test/test.dart';

void main() {
  var sample = [
    "Button A: X+94, Y+34",
    "Button B: X+22, Y+67",
    "Prize: X=8400, Y=5400",
    "",
    "Button A: X+26, Y+66",
    "Button B: X+67, Y+21",
    "Prize: X=12748, Y=12176",
    "",
    "Button A: X+17, Y+86",
    "Button B: X+84, Y+37",
    "Prize: X=7870, Y=6450",
    "",
    "Button A: X+69, Y+23",
    "Button B: X+27, Y+71",
    "Prize: X=18641, Y=10279"
  ];

  var sampleMachines = [
    Machine(94, 34, 22, 67, 8400, 5400),
    Machine(26, 66, 67, 21, 12748, 12176),
    Machine(17, 86, 84, 37, 7870, 6450),
    Machine(69, 23, 27, 71, 18641, 10279),
  ];

  test('Machine from lines', () {
    var m = Machine.fromLines([
      "Button A: X+94, Y+34",
      "Button B: X+22, Y+67",
      "Prize: X=8400, Y=5400"
    ]);

    expect(m.A1, 94);
    expect(m.A2, 34);
    expect(m.B1, 22);
    expect(m.B2, 67);
    expect(m.X, 8400);
    expect(m.Y, 5400);
  });

  test('Machine equal', () {
    var m = Machine(1, 2, 3, 4, 5, 6);

    expect(m == Machine(1, 2, 3, 4, 5, 6), true);
    expect(m == Machine(7, 2, 3, 4, 5, 6), false);
    expect(m == Machine(1, 7, 3, 4, 5, 6), false);
    expect(m == Machine(1, 2, 7, 4, 5, 6), false);
    expect(m == Machine(1, 2, 3, 7, 5, 6), false);
    expect(m == Machine(1, 2, 3, 4, 7, 6), false);
    expect(m == Machine(1, 2, 3, 4, 5, 7), false);
  });

  test('Machines from lines', () async {
    var m = machinesFromLines(Stream.fromIterable(sample));
    expect(await m.toList(), sampleMachines);
  });

  test('Machine solve 1', () {
    var m = Machine(94, 34, 22, 67, 8400, 5400);
    expect(m.solve(), (80, 40));
    expect(m.price(), 280);
    expect(m.solve(delta: 10000000000000), (0, 0));
    expect(m.price(delta: 10000000000000), 0);
  });

  test('Machine solve 2', () {
    var m = Machine(26, 66, 67, 21, 12748, 12176);
    expect(m.solve(), (0, 0));
    expect(m.price(), 0);
    expect(m.solve(delta: 10000000000000), (118679050709, 103199174542));
    expect(m.price(delta: 10000000000000), 459236326669);
  });

  test('Machine solve 3', () {
    var m = Machine(17, 86, 84, 37, 7870, 6450);
    expect(m.solve(), (38, 86));
    expect(m.price(), 200);
    expect(m.solve(delta: 10000000000000), (0, 0));
    expect(m.price(delta: 10000000000000), 0);
  });

  test('Machine solve 4', () {
    var m = Machine(69, 23, 27, 71, 18641, 10279);
    expect(m.solve(), (0, 0));
    expect(m.price(), 0);
    expect(m.solve(delta: 10000000000000), (102851800151, 107526881786));
    expect(m.price(delta: 10000000000000), 416082282239);
  });

  test('price from Machines', () async {
    var p = pricesFromMachines(Stream.fromIterable(sampleMachines));
    expect(await p, (480, 875318608908));
  });
}
