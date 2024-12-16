import 'dart:io';

int gpsCoordsSum(String filePath) {
  var lines = File(filePath).readAsLinesSync();
  var a = Area.fromStrings(lines);
  a.run();
  return a.gpsCoordsSum();
}

enum Cell {
  Empty,
  Robot,
  Box,
  Wall;

  factory Cell.fromString(String s) {
    switch (s) {
      case "@":
        return Robot;
      case "#":
        return Wall;
      case "O":
        return Box;
      default:
        return Empty;
    }
  }
}

typedef Coords = (int, int);
enum Dir{
  North(-1,0),
  South(1,0),
  East(0,1),
  West(0,-1);

  final int x;
  final int y;

  const Dir(this.x, this.y);
  factory Dir.fromString(String s){
    switch(s){
      case ">": return Dir.East;
      case "<": return Dir.West;
      case "^": return Dir.North;
      default: return Dir.South;
    }
  }
}

class Area {
  List<List<Cell>> map = [];
  List<String> instructions = [];
  Coords robot = (0, 0);

  Area(this.map, this.instructions, this.robot);
  Area.fromStrings(List<String> lines) {
    int i = 0;
    for (; i < lines.length && 0 < lines[i].length; ++i) {
      map.add([
        for (int j = 0; j < lines[i].length; ++j) Cell.fromString(lines[i][j])
      ]);
    }
    ++i;
    for (; i < lines.length; ++i) {
      instructions.add(lines[i]);
    }
    robot = detectRobot();
  }

  Coords detectRobot() {
    for (int x = 0; x < map.length; ++x) {
      for (int y = 0; y < map[x].length; ++y) {
        if (map[x][y] == Cell.Robot) return (x, y);
      }
    }
    return (0, 0); // never reached.
  }

  List<Coords> boxes() {
    var res = <Coords>[];
    for (int x = 0; x < map.length; ++x) {
      for (int y = 0; y < map[x].length; ++y) {
        if (map[x][y] == Cell.Box) res.add((x, y));
      }
    }
    return res;
  }

  bool move(Coords p, Dir d) {
    var t = map[p.$1][p.$2];
    if (t == Cell.Wall) return false;
    if (t == Cell.Empty) return true;

    var n = (p.$1 + d.x, p.$2 + d.y);
    if (!move(n, d)) return false;

    map[p.$1][p.$2] = Cell.Empty;
    map[n.$1][n.$2] = t;
    return true;
  }

  bool update(int i, int j){
    var d = Dir.fromString(instructions[i][j]);
    if(move(robot, d)){
      robot = (robot.$1 + d.x, robot.$2 + d.y);
      return true;
    }
    return false;
  }

  void run(){
    for(int i=0; i<instructions.length; ++i){
      for(int j=0; j<instructions[i].length; ++j){
        update(i,j);
      }
    }
  }

  int gpsCoordsSum(){
    return boxes().fold(0, (a, b) => a + 100*b.$1 + b.$2);
  }
}
