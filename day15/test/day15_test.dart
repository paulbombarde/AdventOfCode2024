import 'package:day15/day15.dart';
import 'package:test/test.dart';

void main() {
  var small = [
    "########",
    "#..O.O.#",
    "##@.O..#",
    "#...O..#",
    "#.#.O..#",
    "#...O..#",
    "#......#",
    "########",
    "",
    "<^^>>>vv<v>>v<<"
  ];

  var smallArea = Area.fromStrings(small);

  test('build area', () {
    expect(smallArea.map, [
      [
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall
      ],
      [
        Cell.Wall,
        Cell.Empty,
        Cell.Empty,
        Cell.Box,
        Cell.Empty,
        Cell.Box,
        Cell.Empty,
        Cell.Wall
      ],
      [
        Cell.Wall,
        Cell.Wall,
        Cell.Robot,
        Cell.Empty,
        Cell.Box,
        Cell.Empty,
        Cell.Empty,
        Cell.Wall
      ],
      [
        Cell.Wall,
        Cell.Empty,
        Cell.Empty,
        Cell.Empty,
        Cell.Box,
        Cell.Empty,
        Cell.Empty,
        Cell.Wall
      ],
      [
        Cell.Wall,
        Cell.Empty,
        Cell.Wall,
        Cell.Empty,
        Cell.Box,
        Cell.Empty,
        Cell.Empty,
        Cell.Wall
      ],
      [
        Cell.Wall,
        Cell.Empty,
        Cell.Empty,
        Cell.Empty,
        Cell.Box,
        Cell.Empty,
        Cell.Empty,
        Cell.Wall
      ],
      [
        Cell.Wall,
        Cell.Empty,
        Cell.Empty,
        Cell.Empty,
        Cell.Empty,
        Cell.Empty,
        Cell.Empty,
        Cell.Wall
      ],
      [
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall,
        Cell.Wall
      ]
    ]);

    expect(smallArea.instructions, ["<^^>>>vv<v>>v<<"]);
  });

  test('robot pos', () {
    expect(smallArea.robot, (2, 2));
  });

  test('boxes pos', () {
    expect(smallArea.boxes(), [(1, 3), (1, 5), (2, 4), (3, 4), (4, 4), (5, 4)]);
  });

  test('move', () {
    var a = Area.fromStrings([
      //
      "#####",
      "#.@.#",
      "#.O.#",
      "#...#",
      "#####",
    ]);

    expect(a.move((0, 0), Dir.North), false);
    expect(a.move((0, 0), Dir.South), false);
    expect(a.move((0, 0), Dir.East), false);
    expect(a.move((0, 0), Dir.West), false);

    expect(a.move((1, 1), Dir.North), true);
    expect(a.move((1, 1), Dir.South), true);
    expect(a.move((1, 1), Dir.East), true);
    expect(a.move((1, 1), Dir.West), true);

    expect(a.move((1, 2), Dir.North), false);
    expect(a.robot, (1, 2));
    expect(a.move((1, 2), Dir.East), true);
    expect(a.robot, (1, 3));
    expect(a.move((1, 3), Dir.East), false);
    expect(a.robot, (1, 3));
    expect(a.move((1, 3), Dir.South), true);
    expect(a.robot, (2, 3));
    expect(a.move((2, 3), Dir.North), true);
    expect(a.robot, (1, 3));
    expect(a.move((1, 3), Dir.West), true);
    expect(a.robot, (1, 2));

    expect(a.boxes(), [(2, 2)]);
    expect(a.move((1, 2), Dir.South), true);
    expect(a.robot, (2, 2));
    expect(a.boxes(), [(3, 2)]);
    expect(a.move((2, 2), Dir.South), false);
    expect(a.robot, (2, 2));
    expect(a.boxes(), [(3, 2)]);
  });

  test('move West', () {
    var a = Area.fromStrings([
      //
      "#####",
      "#...#",
      "#.O@#",
      "#...#",
      "#####",
    ]);

    expect(a.robot, (2, 3));
    expect(a.boxes(), [(2, 2)]);
    expect(a.move((2, 3), Dir.West), true);
    expect(a.robot, (2, 2));
    expect(a.boxes(), [(2, 1)]);
    expect(a.move((2, 2), Dir.West), false);
    expect(a.robot, (2, 2));
    expect(a.boxes(), [(2, 1)]);
  });

  test('move east', () {
    var a = Area.fromStrings([
      //
      "#####",
      "#...#",
      "#@O.#",
      "#...#",
      "#####",
    ]);

    expect(a.robot, (2, 1));
    expect(a.boxes(), [(2, 2)]);
    expect(a.move((2, 1), Dir.East), true);
    expect(a.robot, (2, 2));
    expect(a.boxes(), [(2, 3)]);
    expect(a.move((2, 2), Dir.East), false);
    expect(a.robot, (2, 2));
    expect(a.boxes(), [(2, 3)]);
  });

  test('move north', () {
    var a = Area.fromStrings([
      //
      "#####",
      "#...#",
      "#.O.#",
      "#.@.#",
      "#####",
    ]);

    expect(a.robot, (3, 2));
    expect(a.boxes(), [(2, 2)]);
    expect(a.move((3, 2), Dir.North), true);
    expect(a.robot, (2, 2));
    expect(a.boxes(), [(1, 2)]);
    expect(a.move((2, 2), Dir.North), false);
    expect(a.robot, (2, 2));
    expect(a.boxes(), [(1, 2)]);
  });

  test('update', () {
    var a = Area.fromStrings(small);

    expect(a.robot, (2, 2));
    expect(a.update(0, 0), false);
    expect(a.robot, (2, 2));
    expect(a.update(0, 1), true);
    expect(a.robot, (1, 2));
    expect(a.update(0, 2), false);
    expect(a.robot, (1, 2));
    expect(a.update(0, 3), true);
    expect(a.robot, (1, 3));
    expect(a.update(0, 4), true);
    expect(a.robot, (1, 4));
    expect(a.update(0, 5), false);
    expect(a.robot, (1, 4));
    expect(a.update(0, 6), true);
    expect(a.robot, (2, 4));
    expect(a.update(0, 7), false);
    expect(a.robot, (2, 4));
    expect(a.update(0, 8), true);
    expect(a.robot, (2, 3));
  });

  test('run', () {
    var a = Area.fromStrings(small);
    a.run();
    expect(a.robot, (4, 4));
    expect(a.boxes(), [(1, 5), (1, 6), (3, 6), (4, 3), (5, 4), (6, 4)]);
    expect(a.gpsCoordsSum(), 2028);
  });

  var medium = [
    "##########",
    "#..O..O.O#",
    "#......O.#",
    "#.OO..O.O#",
    "#..O@..O.#",
    "#O#..O...#",
    "#O..O..O.#",
    "#.OO.O.OO#",
    "#....O...#",
    "##########",
    "",
    "<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^",
    "vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v",
    "><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<",
    "<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^",
    "^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><",
    "^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^",
    ">^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^",
    "<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>",
    "^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>",
    "v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^"
  ];

  test('run medium', () {
    var m = Area.fromStrings(medium);
    m.run();
    expect(m.robot, (4, 3));
    expect(Set.from(m.boxes()), {
      (1, 2), (1, 4), (1, 6), (1, 7), (1, 8), //
      (3, 1), (3, 2), //
      (4, 1), (4, 2), //
      (5, 1), (5, 8), //
      (6, 1), (6, 7), (6, 8), //
      (7, 1), (7, 7), (7, 8), //
      (8, 1), (8, 2), (8, 7), (8, 8), //
    });
    expect(m.gpsCoordsSum(), 10092);
  });

  test("run2 east", (){
    var a = Area.fromStrings([
      "##############",
      "##        ##",
      "##   []   ##",
      "##  [][]@ ##",
      "##   []   ##",
      "##        ##",
      "############",
      "",
      "<<<"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (3,8));
    expect(a.boxes(), [(2,5), (3, 4),(3, 6),(4,5),]);
    a.run();
    expect(a.robot, (3,6));
    expect(a.boxes(), [(2,5), (3, 2),(3, 4),(4,5),]);

  });

  test("run2 west", (){
    var a = Area.fromStrings([
      "##############",
      "##        ##",
      "##   []   ##",
      "## @[][]  ##",
      "##   []   ##",
      "##        ##",
      "############",
      "",
      ">>>"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (3,3));
    expect(a.boxes(), [(2,5), (3, 4),(3, 6),(4,5),]);
    a.run();
    expect(a.robot, (3,5));
    expect(a.boxes(), [(2,5), (3, 6),(3, 8),(4,5),]);

  });

  test("run2 north", (){
    var a = Area.fromStrings([
      "##############",
      "##        ##",
      "##   []   ##",
      "##  [][]  ##",
      "##   []   ##",
      "##   @    ##",
      "############",
      "",
      "^^^"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (5,5));
    expect(a.boxes(), [(2,5), (3, 4),(3, 6),(4,5),]);
    a.run();
    expect(a.robot, (4,5));
    expect(a.boxes(), [(1,5), (2, 4),(2, 6),(3,5),]);

  });

  test("run2 north2", (){
    var a = Area.fromStrings([
      "##############",
      "##        ##",
      "##   []   ##",
      "##  [][]  ##",
      "##   []   ##",
      "##    @   ##",
      "############",
      "",
      "^^^"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (5,6));
    expect(a.boxes(), [(2,5), (3, 4),(3, 6),(4,5),]);
    a.run();
    expect(a.robot, (4,6));
    expect(a.boxes(), [(1,5), (2, 4),(2, 6),(3,5),]);
  });

  test("run2 south", (){
    var a = Area.fromStrings([
      "##############",
      "##   @    ##",
      "##   []   ##",
      "##  [][]  ##",
      "##   []   ##",
      "##        ##",
      "############",
      "",
      "vvv"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (1,5));
    expect(a.boxes(), [(2,5), (3, 4),(3, 6),(4,5),]);
    a.run();
    expect(a.robot, (2,5));
    expect(a.boxes(), [(3,5), (4, 4),(4, 6),(5,5),]);
  });

  test("run2 south2", (){
    var a = Area.fromStrings([
      "##############",
      "##    @   ##",
      "##   []   ##",
      "##  [][]  ##",
      "##   []   ##",
      "##        ##",
      "############",
      "",
      "vvv"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (1,6));
    expect(a.boxes(), [(2,5), (3, 4),(3, 6),(4,5),]);
    a.run();
    expect(a.robot, (2,6));
    expect(a.boxes(), [(3,5), (4, 4),(4, 6),(5,5),]);
  });

  test("partial block south", (){
    var a = Area.fromStrings([
      "##############",
      "##    @   ##",
      "##   []   ##",
      "##   #    ##",
      "############",
      "",
      "vvv"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (1,6));
    expect(a.boxes(), [(2,5)]);
    a.run();
    expect(a.robot, (1,6));
    expect(a.boxes(), [(2,5)]);
  });

  test("partial block south2", (){
    var a = Area.fromStrings([
      "##############",
      "##    @   ##",
      "##   []   ##",
      "##    #   ##",
      "############",
      "",
      "vvv"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (1,6));
    expect(a.boxes(), [(2,5)]);
    a.run();
    expect(a.robot, (1,6));
    expect(a.boxes(), [(2,5)]);
  });

  test("partial block north", (){
    var a = Area.fromStrings([
      "##############",
      "##   #    ##",
      "##   []   ##",
      "##    @   ##",
      "############",
      "",
      "^^^"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (3,6));
    expect(a.boxes(), [(2,5)]);
    a.run();
    expect(a.robot, (3,6));
    expect(a.boxes(), [(2,5)]);
  });

  test("partial block north2", (){
    var a = Area.fromStrings([
      "##############",
      "##    #   ##",
      "##   []   ##",
      "##    @   ##",
      "############",
      "",
      "^^^"
    ]);

    expect(a.mode, 2);
    expect(a.robot, (3,6));
    expect(a.boxes(), [(2,5)]);
    a.run();
    expect(a.robot, (3,6));
    expect(a.boxes(), [(2,5)]);
  });

  test('run2 smaller', () {
    var smaller = [
      "#######",
      "#...#.#",
      "#.....#",
      "#..OO@#",
      "#..O..#",
      "#.....#",
      "#######",
      "",
      "<vv<<^^<<^^"
    ];

    var a = Area.fromStringsWide(smaller);
    a.run();
    expect(a.robot, (2, 5));
    expect(a.boxes(), [(1, 5), (2, 7), (3, 6)]);
    expect(a.gpsCoordsSum(), 618);
  });

  test('run2 medium', () {
    var m = Area.fromStringsWide(medium);
    m.run();
    expect(m.robot, (7, 4));
    expect(Set.from(m.boxes()), {
      (1, 2), (1, 11), (1, 14), (1, 16), //
      (2, 2), (2, 15), //
      (3, 2), (3, 12), (3, 14), (3, 16), //
      (4, 2), (4, 10), (4, 16), //
      (5, 12), //
      (6, 4), //
      (7, 11), (7, 14), (7, 16), //
      (8, 8), (8, 10), (8, 14), //
    });
    expect(m.gpsCoordsSum(), 9021);
  });
}
