import 'dart:io';

(int, int) gpsCoordsSum(String filePath) {
  var lines = File(filePath).readAsLinesSync();
  var a = Area.fromStrings(lines);
  print("Instructions: ${a.instructions.fold(0, (acc, l) => acc + l.length)}");
  a.run();
  var a2 = Area.fromStringsWide(lines);
  a2.run();
  return (a.gpsCoordsSum(), a2.gpsCoordsSum());
}

enum Cell {
  Empty,
  Robot,
  Box,
  BoxEnd,
  Wall;

  factory Cell.fromString(String s) {
    switch (s) {
      case "@":
        return Robot;
      case "#":
        return Wall;
      case "O":
      case "[":
        return Box;
      case "]":
        return BoxEnd;
      default:
        return Empty;
    }
  }

  factory Cell.wider(Cell c) {
    switch (c) {
      case Cell.Robot:
        return Cell.Empty;
      case Cell.Box:
        return Cell.BoxEnd;
      default:
        return c;
    }
  }
  
  int charCode(){
    switch(this){
      case Robot: return "@".codeUnitAt(0);
      case Wall: return "#".codeUnitAt(0);
      case Box: return "[".codeUnitAt(0);
      case BoxEnd: return "]".codeUnitAt(0);
      case Empty: return " ".codeUnitAt(0);
    }
  }
}

typedef Coords = (int, int);

enum Dir {
  North(-1, 0),
  South(1, 0),
  East(0, 1),
  West(0, -1);

  final int x;
  final int y;

  const Dir(this.x, this.y);
  factory Dir.fromString(String s) {
    switch (s) {
      case ">":
        return Dir.East;
      case "<":
        return Dir.West;
      case "^":
        return Dir.North;
      default:
        return Dir.South;
    }
  }
}

class Area {
  List<List<Cell>> map = [];
  List<String> instructions = [];
  Coords robot = (0, 0);
  int mode = 1;

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
    mode = detectMode();
  }

  Area.fromStringsWide(List<String> lines) {
    int i = 0;
    for (; i < lines.length && 0 < lines[i].length; ++i) {
      map.add(mapLineFromString2(lines[i]));
    }
    ++i;
    for (; i < lines.length; ++i) {
      instructions.add(lines[i]);
    }
    robot = detectRobot();
    mode = 2;
  }

  static List<Cell> mapLineFromString2(String line) {
    var res = <Cell>[];
    for (int j = 0; j < line.length; ++j) {
      var c = Cell.fromString(line[j]);
      res.add(c);
      res.add(Cell.wider(c));
    }
    return res;
  }

  Coords detectRobot() {
    for (int x = 0; x < map.length; ++x) {
      for (int y = 0; y < map[x].length; ++y) {
        if (map[x][y] == Cell.Robot) return (x, y);
      }
    }
    return (0, 0); // never reached.
  }

  int detectMode() {
    for (int x = 0; x < map.length; ++x) {
      for (int y = 0; y < map[x].length; ++y) {
        if (map[x][y] == Cell.BoxEnd) return 2;
      }
    }
    return 1;
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
    if (t == Cell.Robot) {
      robot = n;
    }
    return true;
  }

  bool move2(Coords p, Dir d) {
    var t = map[p.$1][p.$2];
    if (t == Cell.Wall) return false;
    if (t == Cell.Empty) return true;

    var n = (p.$1 + d.x, p.$2 + d.y);
    if (!canMove2(n, d)) return false;

    if (t == Cell.Box && (d == Dir.North || d == Dir.South)) {
      var m = (p.$1 + d.x, p.$2 + 1 + d.y); // right side
      if (!canMove2(m, d)) return false;
      move2(m, d);
      map[m.$1][m.$2] = map[p.$1][p.$2 + 1];
      map[p.$1][p.$2 + 1] = Cell.Empty;
    }

    if (t == Cell.BoxEnd && (d == Dir.North || d == Dir.South)) {
      var m = (p.$1 + d.x, p.$2 - 1 + d.y); // left side
      if (!canMove2(m, d)) return false;
      move2(m, d);
      map[m.$1][m.$2] = map[p.$1][p.$2 - 1];
      map[p.$1][p.$2 - 1] = Cell.Empty;
    }

    move2(n, d);
    map[p.$1][p.$2] = Cell.Empty;
    map[n.$1][n.$2] = t;
    if (t == Cell.Robot) {
      robot = n;
    }

    return true;
  }

  bool canMove2(Coords p, Dir d) {
    var t = map[p.$1][p.$2];
    if (t == Cell.Wall) return false;
    if (t == Cell.Empty) return true;

    var n = (p.$1 + d.x, p.$2 + d.y);
    if (!canMove2(n, d)) return false;

    if (t == Cell.Box && (d == Dir.North || d == Dir.South)) {
      var m = (p.$1 + d.x, p.$2 + 1 + d.y); // right side
      return canMove2(m, d);
    }

    if (t == Cell.BoxEnd && (d == Dir.North || d == Dir.South)) {
      var m = (p.$1 + d.x, p.$2 - 1 + d.y); // left side
      return canMove2(m, d);
    }

    return true;
  }

  bool update(int i, int j) {
    var d = Dir.fromString(instructions[i][j]);
    if (mode == 1 && move(robot, d) || move2(robot, d)) {
      return true;
    }
    return false;
  }

  void run() {
    for (int i = 0; i < instructions.length; ++i) {
      for (int j = 0; j < instructions[i].length; ++j) {
        update(i, j);
      }
    }
  }

  int gpsCoordsSum() {
    return boxes().fold(0, (a, b) => a + 100 * b.$1 + b.$2);
  }

  void display(){
    for(int i=0; i<map.length; ++i){
      print(String.fromCharCodes([for (var c in map[i]) c.charCode()]));
    }
  }
}
