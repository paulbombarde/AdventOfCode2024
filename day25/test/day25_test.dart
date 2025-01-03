import 'package:day25/day25.dart';
import 'package:test/test.dart';

void main() {
  var sample = [
    "#####",
    ".####",
    ".####",
    ".####",
    ".#.#.",
    ".#...",
    ".....",
    "",
    "#####",
    "##.##",
    ".#.##",
    "...##",
    "...#.",
    "...#.",
    ".....",
    "",
    ".....",
    "#....",
    "#....",
    "#...#",
    "#.#.#",
    "#.###",
    "#####",
    "",
    ".....",
    ".....",
    "#.#..",
    "###..",
    "###.#",
    "###.#",
    "#####",
    "",
    ".....",
    ".....",
    ".....",
    "#....",
    "#.#..",
    "#.#.#",
    "#####",
  ];
  var sampleBlocks = [
    [
      "#####",
      ".####",
      ".####",
      ".####",
      ".#.#.",
      ".#...",
      ".....",
    ],
    [
      "#####",
      "##.##",
      ".#.##",
      "...##",
      "...#.",
      "...#.",
      ".....",
    ],
    [
      ".....",
      "#....",
      "#....",
      "#...#",
      "#.#.#",
      "#.###",
      "#####",
    ],
    [
      ".....",
      ".....",
      "#.#..",
      "###..",
      "###.#",
      "###.#",
      "#####",
    ],
    [
      ".....",
      ".....",
      ".....",
      "#....",
      "#.#..",
      "#.#.#",
      "#####",
    ]
  ];

  var sampleBlocksData = [
    BlockData(Type.Lock, [1, 6, 4, 5, 4]), // [0, 5, 3, 4, 3]),
    BlockData(Type.Lock, [2, 3, 1, 6, 4]), // [1, 2, 0, 5, 3]),
    BlockData(Type.Key, [1, 6, 4, 5, 3]), // [5, 0, 2, 1, 3]),
    BlockData(Type.Key, [2, 3, 2, 6, 4]), // [4, 3, 4, 0, 2]),
    BlockData(Type.Key, [3, 6, 4, 6, 5]), // [3, 0, 2, 0, 1])
  ];

  test('generates blocks', () async {
    var lines = Stream.fromIterable(sample);
    var blocks = await blocksFromLines(lines).toList();
    expect(blocks, sampleBlocks);
  });
  test('generates blocksData', () async {
    var blocks = Stream.fromIterable(sampleBlocks);
    var blocksData = await blocksDataFromBlocks(blocks).toList();
    expect(blocksData, sampleBlocksData);
  });
  test('key fits lock', (){
    expect(keyFitsLock([1, 6, 4, 5, 3], [1, 6, 4, 5, 4]), 0);
    expect(keyFitsLock([2, 3, 2, 6, 4], [1, 6, 4, 5, 4]), 0);
    expect(keyFitsLock([3, 6, 4, 6, 5], [1, 6, 4, 5, 4]), 1);
    expect(keyFitsLock([1, 6, 4, 5, 3], [2, 3, 1, 6, 4]), 0);
    expect(keyFitsLock([2, 3, 2, 6, 4], [2, 3, 1, 6, 4]), 1);
    expect(keyFitsLock([3, 6, 4, 6, 5], [2, 3, 1, 6, 4]), 1);
  });

  test('count fitting locks', (){
    var sampleLocks = {[1, 6, 4, 5, 4], [2, 3, 1, 6, 4]};
    expect(numberFittingLocks([1, 6, 4, 5, 3], sampleLocks), 0);
    expect(numberFittingLocks([2, 3, 2, 6, 4], sampleLocks), 1);
    expect(numberFittingLocks([3, 6, 4, 6, 5], sampleLocks), 2);
  });

  test('counts pairs', () async {
    var lines = Stream.fromIterable(sample);
    var c = await numberFittingPairsFromLines(lines);
    expect(c, 3);
  });
}
