import 'dart:io';
import 'dart:collection';
import 'dart:math';

int calculate(String filePath) {
  var lines = File(filePath).readAsLinesSync();
  var t = Track.fromLines(lines);
  var cheats = t.cheats();
  return nbCheats(countCheats(cheats), 100);
}

typedef Coords = (int, int);
typedef Path = List<Coords>;
typedef Cheat = (Coords, Coords, int); // first, second, saving

enum Dir {
  North(-1, 0),
  South(1, 0),
  East(0, 1),
  West(0, -1);

  final int x;
  final int y;
  const Dir(this.x, this.y);

  Coords next(Coords c) {
    return (c.$1 + x, c.$2 + y);
  }
}

class Track {
  final List<String> map;
  final Coords start;
  final Coords end;
  final int infinity;

  var distFromStart = <Coords, int>{};
  var distToEnd = <Coords, int>{};

  Track(this.map, this.start, this.end)
      : infinity = map.length * map[0].length {
    initialize();
  }

  factory Track.fromLines(List<String> lines) {
    var start = (0, 0);
    var end = (0, 0);
    for (int i = 0; i < lines.length; ++i) {
      for (int j = 0; j < lines[i].length; ++j) {
        if ("S" == lines[i][j]) start = (i, j);
        if ("E" == lines[i][j]) end = (i, j);
      }
    }
    return Track(lines, start, end);
  }

  void initialize() {
    distFromStart[start] = 0;
    distToEnd[end] = 0;
    computeDists(start, distFromStart);
    computeDists(end, distToEnd);
  }

  void computeDists(Coords s, Map<Coords, int> dists) {
    var seen = <Coords>{};
    var q = Queue<Coords>();
    q.addFirst(s);
    while (!q.isEmpty) {
      var c = q.removeLast();
      seen.add(c);

      for (var d in Dir.values) {
        var n = d.next(c);
        if (seen.contains(n)) continue;
        if (!isValid(n)) continue;

        dists[n] = dists[c]! + 1;
        q.addFirst(n);
      }
    }
  }

  bool isValid(Coords c) {
    if (c.$1 < 0 || c.$2 < 0 || map.length <= c.$1 || map[0].length <= c.$2)
      return false;
    return "#" != map[c.$1][c.$2];
  }

  int shortest() {
    return distFromStart[end]!;
  }

  int cheat(Coords first, Coords second) {
    if (isValid(first) || !isValid(second)) return -1;
    if (!distToEnd.containsKey(second)) return -1;

    int fromStart = infinity;
    for (var d in Dir.values) {
      var f = d.next(first);
      if (f == second) continue;
      if (!distFromStart.containsKey(f)) continue;
      fromStart = min(fromStart, distFromStart[f]!);
    }

    if (fromStart == infinity) return -1;
    return fromStart + distToEnd[second]! + 2;
  }

  List<Cheat> cheats() {
    var ref = shortest();
    var cheats = <Cheat>[];

    for (int i = 1; i < map.length - 1; ++i) {
      for (int j = 1; j < map[i].length - 1; ++j) {
        var first = (i, j);
        for (var d in Dir.values) {
          var second = d.next(first);
          var v = cheat(first, second);
          if (v < 0 || ref <= v) continue;
          cheats.add((first, second, ref - v));
        }
      }
    }
    return cheats;
  }
}

Map<int, int> countCheats(List<Cheat> cheats) {
  var counts = <int, int>{};
  for (var cheat in cheats) {
    counts[cheat.$3] = (counts[cheat.$3] ?? 0) + 1;
  }
  return counts;
}

int nbCheats(Map<int, int> cheatCounts, int threshold){
  var n=0;
  for(var e in cheatCounts.entries){
    if(e.key < threshold) continue;
    n+=e.value;
  }
  return n;
}
