import 'package:day8/day8.dart';
import 'package:test/test.dart';

void main() {
  var map = [
    "............",
    "........0...",
    ".....0......",
    ".......0....",
    "....0.......",
    "......A.....",
    "............",
    "............",
    "........A...",
    ".........A..",
    "............",
    "............"
  ];

  test('antennas per freq', () {
    var expected = {
      "0": [(1, 8), (2, 5), (3, 7), (4, 4)],
      "A": [(5, 6), (8, 8), (9, 9)]
    };
    expect(antennasPerFreq(map), expected);
  });

  test('antinode 1', () {
    var map1 = [
      "..........",
      "...#......", // (1,3)
      "..........",
      "....a.....", // (3,4)
      "..........",
      ".....a....", // (5,5)
      "..........",
      "......#...", // (7,6)
      "..........",
      ".........."
    ];

    var antennas = antennasPerFreq(map1);
    expect(
        antinodesForAntennas(map1, antennas["a"]!), Set.from(antennas["#"]!));
  });

  test('antinode 2', () {
    var map1 = [
      "..........",
      "...#......", // (1,3)
      "#.........", // (2,0)
      "....a.....", // (3,4)
      "........a.", // (4,8)
      ".....a....", // (5,5)
      "..#.......", // (6,2)
      "......#...", // (7,6)
      "..........",
      ".........."
    ];

    var antennas = antennasPerFreq(map1);
    expect(
        antinodesForAntennas(map1, antennas["a"]!), Set.from(antennas["#"]!));
  });

  test('antinode T', () {
    var map1 = [
      'T....#....',
      '...T......',
      '.T....#...',
      '.........#',
      '..#.......',
      '..........',
      '...#......',
      '..........',
      '....#.....',
      '..........'
    ];

    var antennas = antennasPerFreq(map1);
    var res = {...antennas["#"]!, ...antennas["T"]!};
    expect(allAntinodesForAntennas(map1, antennas["T"]!), res);
  });

  test('all antinodes', () {
    var antinodes = {
      "0": {
        (0, 11),
        (3, 2),
        (5, 6),
        (7, 0),
        (1, 3),
        (4, 9),
        (0, 6),
        (6, 3),
        (2, 10),
        (5, 1)
      },
      "A": {(2, 4), (11, 10), (1, 3), (7, 7), (10, 10)}
    };
    expect(antinodesForMap(map), antinodes);
  });

  test('antinodes count', () {
    var antinodes = {
      "0": {
        (0, 11),
        (3, 2),
        (5, 6),
        (7, 0),
        (1, 3),
        (4, 9),
        (0, 6),
        (6, 3),
        (2, 10),
        (5, 1)
      },
      "A": {(2, 4), (11, 10), (1, 3), (7, 7), (10, 10)}
    };
    expect(antinodesCount(antinodes), 14);
  });
}
