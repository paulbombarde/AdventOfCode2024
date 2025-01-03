import 'package:day20/day20.dart';
import 'package:test/test.dart';

void main() {
  var sample = [
    "###############",
    "#...#...#.....#",
    "#.#.#.#.#.###.#",
    "#S#...#.#.#...#",
    "#######.#.#.###",
    "#######.#.#...#",
    "#######.#.###.#",
    "###..E#...#...#",
    "###.#######.###",
    "#...###...#...#",
    "#.#####.#.###.#",
    "#.#...#.#.#...#",
    "#.#.#.#.#.#.###",
    "#...#...#...###",
    "###############",
  ];
  test('shortest', () {
    var t = Track.fromLines(sample);
    expect(t.shortest(), 84);
  });

  test('cheat', () {
    var t = Track.fromLines(sample);
    expect(t.cheat((1, 7), (1, 9)), 72);
    expect(t.cheat((7, 9), (7, 11)), 64);
    expect(t.cheat((7, 8), (9, 8)), 46);
    expect(t.cheat((7, 7), (7, 5)), 20);
    expect(t.cheat((3, 1), (7, 3)), 8);
  });
  test('cheatCount', () {
    var t = Track.fromLines(sample);
    var sampleCounts2 = {
      2: 14,
      4: 14,
      6: 2,
      8: 4,
      10: 2,
      12: 3,
      20: 1,
      36: 1,
      38: 1,
      40: 1,
      64: 1
    };

    var cheats2 = t.cheats(2);
    expect(cheats2, {
      ((1, 3), (1, 5)): 4,
      ((1, 7), (1, 9)): 12,
      ((2, 1), (2, 3)): 2,
      ((2, 3), (2, 5)): 2,
      ((2, 5), (2, 7)): 2,
      ((2, 7), (2, 9)): 10,
      ((1, 11), (3, 11)): 4,
      ((1, 12), (3, 12)): 2,
      ((3, 1), (3, 3)): 4,
      ((3, 5), (3, 7)): 4,
      ((3, 7), (3, 9)): 8,
      ((3, 9), (3, 11)): 8,
      ((4, 7), (4, 9)): 6,
      ((4, 9), (4, 11)): 10,
      ((3, 12), (5, 12)): 2,
      ((3, 13), (5, 13)): 4,
      ((5, 7), (5, 9)): 4,
      ((5, 9), (5, 11)): 12,
      ((6, 7), (6, 9)): 2,
      ((5, 11), (7, 11)): 4,
      ((5, 12), (7, 12)): 2,
      ((7, 7), (7, 5)): 64,
      ((7, 9), (7, 11)): 20,
      ((7, 7), (9, 7)): 40,
      ((7, 8), (9, 8)): 38,
      ((7, 9), (9, 9)): 36,
      ((7, 12), (9, 12)): 2,
      ((7, 13), (9, 13)): 4,
      ((9, 11), (9, 9)): 12,
      ((11, 3), (9, 3)): 8,
      ((10, 9), (10, 7)): 2,
      ((9, 11), (11, 11)): 4,
      ((9, 12), (11, 12)): 2,
      ((11, 3), (11, 1)): 4,
      ((11, 7), (11, 5)): 4,
      ((11, 9), (11, 7)): 4,
      ((11, 11), (11, 9)): 4,
      ((12, 3), (12, 1)): 2,
      ((12, 5), (12, 3)): 2,
      ((12, 7), (12, 5)): 2,
      ((12, 9), (12, 7)): 6,
      ((12, 11), (12, 9)): 2,
      ((13, 5), (13, 3)): 4,
      ((13, 9), (13, 7)): 8
    });
    var counts2 = countCheats(cheats2, 0);

    expect(counts2, sampleCounts2);
    counts2 = countCheats(cheats2, 20);
    expect(nbCheats(counts2), 5);
  });

  test('cheatCount 20', () {
    var t = Track.fromLines(sample);
    var cheats20 = t.cheats(20);
    var counts20 = countCheats(cheats20, 50);

    expect(counts20, {
      50: 32,
      52: 31,
      54: 29,
      56: 39,
      58: 25,
      60: 23,
      62: 20,
      64: 19,
      66: 12,
      68: 14,
      70: 12,
      72: 22,
      74: 4,
      76: 3
    });
  });
}
