import 'dart:io';
import 'dart:collection';

int calculate(String filePath) {
  var lines = File(filePath).readAsLinesSync();

  var map = MMap.fromLines(lines.take(1024), 70);
  return map.shortest();
}

typedef Coords = (int, int);
Coords readLine(String line) {
  var coords = line.split(',');
  return (int.parse(coords[0]), int.parse(coords[1]));
}

enum Dir {
  North(0, -1),
  South(0, 1),
  East(1, 0),
  West(-1, 0);

  final int x;
  final int y;

  const Dir(this.x, this.y);
  Coords next(Coords c) {
    return (c.$1 + x, c.$2 + y);
  }
}

class MMap {
  final Set<Coords> corrupted;
  final int size;

  MMap(this.corrupted, this.size);

  factory MMap.fromLines(Iterable<String> lines, int size) {
    var corrupted = {for (var l in lines) readLine(l)};
    return MMap(corrupted, size);
  }

  bool valid(Coords c) {
    return 0 <= c.$1 && 0 <= c.$2 && c.$1 <= size && c.$2 <= size && !corrupted.contains(c);
  }

  int shortest() {
    var q = Queue<Coords>();
    var dists = <Coords, int>{(0, 0): 0};
    q.addFirst((0, 0));

    while (!q.isEmpty) {
      var c = q.removeLast();
      for (var d in Dir.values) {
        var n = d.next(c);
        if (dists.containsKey(n) || !valid(n)) continue;
        dists[n] = dists[c]! + 1;
        if(n == (size, size)) return dists[n]!;
        q.addFirst(n);
      }
    }

    return dists[(size, size)]!;
  }
}
