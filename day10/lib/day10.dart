import 'dart:io';

(int, int) computePathsCountFromFile(String filePath){
  var lines = File(filePath).readAsLinesSync();
  var topo = Topo.fromStrings(lines);
  return topo.computeMapScore();
}

typedef Coords = (int, int);

class Topo {
  final List<List<int>> map;

  Topo(this.map);

  static List<List<int>> parseLines(List<String> lines) {
    return [
      for (var l in lines) [for (int i = 0; i < l.length; ++i) int.parse(l[i])]
    ];
  }

  Topo.fromStrings(List<String> lines) : map = parseLines(lines);

  Set<Coords> heads() {
    var res = <Coords>{};
    for (int x = 0; x < map.length; ++x) {
      for (int y = 0; y < map[x].length; ++y) {
        if (map[x][y] == 0) res.add((x, y));
      }
    }
    return res;
  }

  Set<Coords> next(Coords c) {
    var res = <Coords>{};
    var v = map[c.$1][c.$2] + 1;

    for (var dx in [-1, 1]) {
      var x = c.$1 + dx;
      if (0 <= x && x < map.length && v == map[x][c.$2]) res.add((x, c.$2));

      var y = c.$2 + dx;
      if (0 <= y && y < map[c.$1].length && v == map[c.$1][y])
        res.add((c.$1, y));
    }
    return res;
  }

 (int, int) computeTrailHeadScore(Coords head) {
    var current = [head];
    var nines = <Coords>{};
    var pathCounts = 0;
    while (!current.isEmpty) {
      var nextCoords = next(current.removeLast());
      for (var c in nextCoords) {
        if (map[c.$1][c.$2] == 9) {
          nines.add(c);
          pathCounts++;
        } else {
          current.add(c);
        }
      }
    }
    return (nines.length, pathCounts);
  }

  (int, int) computeMapScore() {
    int ninesCount = 0;
    int pathCount = 0;
    for (var head in heads()) {
      var (n,p)= computeTrailHeadScore(head);
      ninesCount += n;
      pathCount += p;
    }
    return (ninesCount, pathCount);
  }
}
