import 'package:equatable/equatable.dart';
import 'dart:io';

(int, int) guardPahtLengthFromFile(String filePath) {
  var lines = File(filePath).readAsLinesSync();
  var solver = Solver.fromLines(lines);
  var solution = solver.solve();
  var blocks = solver.blockPositionsForCycle(solution);
  return (solution.positions().length, blocks.length);
}

enum Dir {
  North,
  East,
  South,
  West;
}

class Guard extends Equatable {
  final int x;
  final int y;
  final d;

  Guard(this.x, this.y, this.d);
  Guard copy() {
    return Guard(x, y, d);
  }

  @override
  List<Object?> get props => [x, y, d];

  Guard step() {
    switch (d) {
      case Dir.North:
        return Guard(x - 1, y, d);
      case Dir.South:
        return Guard(x + 1, y, d);
      case Dir.East:
        return Guard(x, y + 1, d);
      case Dir.West:
        return Guard(x, y - 1, d);
    }
    throw 'Unknown direction!';
  }

  Guard turn() {
    switch (d) {
      case Dir.North:
        return Guard(x, y, Dir.East);
      case Dir.East:
        return Guard(x, y, Dir.South);
      case Dir.South:
        return Guard(x, y, Dir.West);
      case Dir.West:
        return Guard(x, y, Dir.North);
    }
    throw 'Unknown direction!';
  }
}

class Map {
  List<List<String>> map = [];

  Map(List<String> lines) {
    for (var l in lines) {
      map.add([for (int i = 0; i < l.length; ++i) l[i]]);
    }
  }

  Guard guardStart() {
    for (int x = 0; x < map.length; ++x) {
      for (int y = 0; y < map[x].length; ++y) {
        if (map[x][y] == '^') {
          return Guard(x, y, Dir.North);
        }
      }
    }
    throw 'No guard found!';
  }

  Guard moveGuard(final Guard guard) {
    var turned = guard.copy();
    for (int i = 0; i < 4; ++i) {
      var next = turned.step();
      if (guardIsOut(next) || map[next.x][next.y] != "#") {
        return next;
      }
      turned = turned.turn();
    }
    throw 'No move possible!';
  }

  bool guardIsOut(final Guard guard) {
    return guard.x < 0 ||
        guard.y < 0 ||
        map.length <= guard.x ||
        map[guard.x].length <= guard.y;
  }

  void blockPosition(int x, int y) {
    map[x][y] = "#";
  }

  void unblockPosition(int x, int y) {
    map[x][y] = ".";
  }
}

class Solution {
  Set<Guard> path = {};
  int res = 0;

  Set<(int, int)> positions() {
    return {for (var g in path) (g.x, g.y)};
  }
}

class Solver {
  Map map;
  Guard g;

  Solver(Map m)
      : map = m,
        g = m.guardStart();

  Solver.fromLines(List<String> lines) : this(Map(lines));

  Solution solve() {
    g = map.guardStart();

    var s = Solution();
    while (!map.guardIsOut(g)) {
      if (s.path.contains(g)) {
        s.res = -1;
        break;
      }
      s.path.add(g);
      g = map.moveGuard(g);
    }

    return s;
  }

  // Expects 'solve' to be called previously and that solution is passed as input.
  Set<(int, int)> blockPositionsForCycle(Solution s) {
    var blockPositions = <(int, int)>{};

    for (var (x, y) in s.positions()) {
      if (map.map[x][y] == "^") continue;
      if (createsCycle(x, y)) blockPositions.add((x, y));
    }

    return blockPositions;
  }

  bool createsCycle(int x, int y) {
    map.blockPosition(x, y);
    var s = solve();
    map.unblockPosition(x, y);
    return s.res == -1;
  }
}
