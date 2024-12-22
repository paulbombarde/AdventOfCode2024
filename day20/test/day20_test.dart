import 'dart:math';

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

  test('cheat', (){
    var t = Track.fromLines(sample);
    expect(t.cheat((1,8), (1,9)), 72);
    expect(t.cheat((7,10), (7,11)), 64);
    expect(t.cheat((8,8), (9,8)), 46);
    expect(t.cheat((7,6), (7,5)), 20);
  });
  test('cheatCount', (){
    var t = Track.fromLines(sample);
    var sampleCounts = {2:14, 4:14, 6:2, 8:4, 10:2, 12:3, 20:1, 36:1, 38:1, 40:1, 64:1};
    var sampleTotal = sampleCounts.values.fold(0, (a,v)=>a+v);

    var cheats = t.cheats();
    expect(cheats.length, sampleTotal);
    var counts = countCheats(cheats);
    expect(counts, sampleCounts);
    expect(nbCheats(counts, 20), 5);
  });
}
