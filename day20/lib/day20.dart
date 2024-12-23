import 'dart:io';
import 'dart:collection';

(int, int) calculate(String filePath) {
  var lines = File(filePath).readAsLinesSync();
  var t = Track.fromLines(lines);
  var cheats2 = t.cheats(2);
  var cheats20 = t.cheats(20);
  return (
    nbCheats(countCheats(cheats2, 100)),
    nbCheats(countCheats(cheats20, 100))
  );
}

typedef Coords = (int, int);
typedef Path = List<Coords>;
typedef Cheat = (Coords, Coords); // first, second, saving

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
    if(c.$1 < 0 ||
        c.$2 < 0 ||
        map.length <= c.$1 ||
        map[0].length <= c.$2) return false;
    return "#" != map[c.$1][c.$2];
  }

  int shortest() {
    return distFromStart[end]!;
  }

  int cheat(Coords first, Coords last) {
    if (!isValid(first) || !isValid(last)) return -1;
    if (!distFromStart.containsKey(first) || !distToEnd.containsKey(last)) return -1;

    int dx = (first.$1 - last.$1).abs();
    int dy = (first.$2 - last.$2).abs();
    return distFromStart[first]! + distToEnd[last]! + dx + dy;
  }

  Map<Cheat, int> cheats(int dist) {
    var ref = shortest();
    var cheats = <Cheat, int>{};

    var deltas = <Coords>[];
    for (int d = 1; d <= dist; ++d) {
      for (int dx = 0; dx <= d; ++dx) {
        int dy = d - dx;
        deltas.add((dx, dy));
        deltas.add((-dx, dy));
        deltas.add((dx, -dy));
        deltas.add((-dx, -dy));
      }
    }

    for (int i = 0; i < map.length - 1; ++i) {
      for (int j = 0; j < map[i].length - 1; ++j) {
        var first = (i, j);
        if (!isValid(first)) continue;

        for (var delta in deltas) {
          var last = (first.$1 + delta.$1, first.$2 + delta.$2);
          var v = cheat(first, last);
          if (v < 0 || ref <= v) continue;
          cheats[(first, last)] = ref - v;
        }
      }
    }
    return cheats;
  }
}

Map<int, int> countCheats(Map<Cheat, int> cheats, int threshold) {
  var counts = <int, int>{};
  for (var cheat in cheats.entries) {
    if (cheat.value < threshold) continue;
    counts[cheat.value] = (counts[cheat.value] ?? 0) + 1;
  }
  return counts;
}

int nbCheats(Map<int, int> cheatCounts) {
  var n = 0;
  for (var e in cheatCounts.entries) {
    n += e.value;
  }
  return n;
}
