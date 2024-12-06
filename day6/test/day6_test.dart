import 'package:day6/day6.dart';
import 'package:test/test.dart';

void main() {
  var map = [
    "....#.....",
    ".........#",
    "..........",
    "..#.......",
    ".......#..",
    "..........",
    ".#..^.....",
    "........#.",
    "#.........",
    "......#..."
  ];

  test('read guard', () {
    var m = Map(map);
    expect(m.guardStart(), Guard(6, 4, Dir.North));
  });

  test('guard next', () {
    expect(Guard(6, 4, Dir.North).step(), Guard(5, 4, Dir.North));
    expect(Guard(6, 4, Dir.East).step(), Guard(6, 5, Dir.East));
    expect(Guard(6, 4, Dir.South).step(), Guard(7, 4, Dir.South));
    expect(Guard(6, 4, Dir.West).step(), Guard(6, 3, Dir.West));
  });

  test('guard turn', () {
    expect(Guard(6, 4, Dir.North).turn(), Guard(6, 4, Dir.East));
    expect(Guard(6, 4, Dir.East).turn(), Guard(6, 4, Dir.South));
    expect(Guard(6, 4, Dir.South).turn(), Guard(6, 4, Dir.West));
    expect(Guard(6, 4, Dir.West).turn(), Guard(6, 4, Dir.North));
  });

  test('move guard', () {
    var m = Map(map);
    expect(m.moveGuard(Guard(6, 4, Dir.North)), Guard(5, 4, Dir.North));
    expect(m.moveGuard(Guard(1, 4, Dir.North)), Guard(1, 5, Dir.East));
    expect(m.moveGuard(Guard(1, 5, Dir.East)), Guard(1, 6, Dir.East));
    expect(m.moveGuard(Guard(1, 8, Dir.East)), Guard(2, 8, Dir.South));
    expect(m.moveGuard(Guard(2, 8, Dir.South)), Guard(3, 8, Dir.South));
    expect(m.moveGuard(Guard(6, 8, Dir.South)), Guard(6, 7, Dir.West));
    expect(m.moveGuard(Guard(6, 7, Dir.West)), Guard(6, 6, Dir.West));
    expect(m.moveGuard(Guard(6, 2, Dir.West)), Guard(5, 2, Dir.North));

    var map2 = Map([
      ".....",
      "..#..",
      ".#.#.",
      "..#..",
      ".....",
    ]);
    expect(map2.moveGuard(Guard(1, 1, Dir.East)), Guard(1, 0, Dir.West));
    expect(map2.moveGuard(Guard(1, 1, Dir.South)), Guard(1, 0, Dir.West));

    expect(map2.moveGuard(Guard(1, 3, Dir.West)), Guard(0, 3, Dir.North));
    expect(map2.moveGuard(Guard(1, 3, Dir.South)), Guard(0, 3, Dir.North));

    expect(map2.moveGuard(Guard(3, 1, Dir.North)), Guard(4, 1, Dir.South));
    expect(m.moveGuard(Guard(3, 1, Dir.East)), Guard(4, 1, Dir.South));

    expect(map2.moveGuard(Guard(3, 3, Dir.North)), Guard(3, 4, Dir.East));
    expect(map2.moveGuard(Guard(3, 3, Dir.West)), Guard(3, 4, Dir.East));

    var map3 = Map([
      ".....",
      ".#.#.",
      "..#..",
      ".#.#.",
      ".....",
    ]);
    expect(map3.moveGuard(Guard(1, 2, Dir.East)), Guard(0, 2, Dir.North));
    expect(map3.moveGuard(Guard(1, 2, Dir.South)), Guard(0, 2, Dir.North));
    expect(map3.moveGuard(Guard(1, 2, Dir.West)), Guard(0, 2, Dir.North));

    expect(map3.moveGuard(Guard(2, 1, Dir.North)), Guard(2, 0, Dir.West));
    expect(map3.moveGuard(Guard(2, 1, Dir.East)), Guard(2, 0, Dir.West));
    expect(map3.moveGuard(Guard(2, 1, Dir.South)), Guard(2, 0, Dir.West));

    expect(map3.moveGuard(Guard(2, 3, Dir.North)), Guard(2, 4, Dir.East));
    expect(map3.moveGuard(Guard(2, 3, Dir.West)), Guard(2, 4, Dir.East));
    expect(map3.moveGuard(Guard(2, 3, Dir.South)), Guard(2, 4, Dir.East));

    expect(map3.moveGuard(Guard(3, 2, Dir.North)), Guard(4, 2, Dir.South));
    expect(map3.moveGuard(Guard(3, 2, Dir.East)), Guard(4, 2, Dir.South));
    expect(map3.moveGuard(Guard(3, 2, Dir.West)), Guard(4, 2, Dir.South));
  });

  test('solver init', () {
    var s = Solver.fromLines(map);
    expect(s.g, Guard(6, 4, Dir.North));
  });

  test('solver solve', () {
    var s = Solver.fromLines(map).solve();
    expect(s.positions().length, 41);
  });

  var map_cycle = [
    "....#.....",
    ".........#",
    "..........",
    "..#.......",
    ".......#..",
    "..........",
    ".#..^.....",
    "........#.",
    "#.........",
    "......##.."
  ];

  test('solver cycle', () {
    var s = Solver.fromLines(map_cycle).solve();
    expect(s.res, -1);
  });

  test('block positions for cycle', (){
    var solver = Solver.fromLines(map);
    var solution = solver.solve();
    var blocks = solver.blockPositionsForCycle(solution);
    expect(blocks, {(6,3), (7,6), (7,7), (8, 1), (8,3), (9,7)});
  });
}
