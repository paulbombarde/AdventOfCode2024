import 'dart:collection';
import 'dart:math';
import 'dart:io';

int computeSmallestScore(String filePath) {
  var lines = File(filePath).readAsLinesSync();
  var m = Mapp(lines);
  return m.computeSmallestScore();
}

typedef Coord = (int, int);

enum Dir {
  None(0,0),
  North(-1, 0),
  South(1, 0),
  East(0, 1),
  West(0, -1);

  final int x;
  final int y;
  const Dir(this.x, this.y);

  static Dir fromCoords(Coord from, Coord to){
    if(from.$1 == to.$1){
      return (from.$2 < to.$2)?Dir.East:Dir.West;
    }
    if(from.$2 == to.$2){
      return (from.$1 < to.$1)?Dir.South:Dir.North;
    }
    return None;
  }

  static List<Dir> valids(){
    return [Dir.North, Dir.South, Dir.East, Dir.West];
  }

  Dir turnLeft() {
    switch (this) {
      case North:
        return West;
      case South:
        return East;
      case East:
        return North;
      case West:
        return South;
      default:
        return None;
    }
  }

  Dir turnRight() {
    switch (this) {
      case North:
        return East;
      case South:
        return West;
      case East:
        return South;
      case West:
        return North;
      default:
        return None;
    }
  }

  Dir halfTurn(){
    switch (this) {
      case North:
        return South;
      case South:
        return North;
      case East:
        return West;
      case West:
        return East;
      default:
        return None;
    }
  }

  Coord add(Coord p) {
    return (p.$1 + x, p.$2 + y);
  }
}

class Mapp {
  final List<String> map;
  Mapp(this.map);

  bool isWall(Coord p) {
    return map[p.$1][p.$2] == "#";
  }

  int computeSmallestScore() {
    /*
    var g = buildGraph();
    // g.display();
    var start = (map.length - 2, 1);
    var end = (1, map.length - 2);
    return g.computeShortest(start, end);
    */
    return dijkstra();
  }

  Graph buildGraph() {
    var g = Graph();

    var s = (map.length - 2, 1);
    var e = (1, map.length - 2);

    var q = Queue<({Coord current, Coord source, Dir dir, int cost})>();
    var seen = <Coord>{};
    q.addFirst((current: s, source: s, dir: Dir.East, cost: 0));
    while (!q.isEmpty) {
      var l = q.removeLast();
      seen.add(l.current);

      {
        var front = l.dir.add(l.current);
        if (!isWall(front)) {
          q.addFirst(
              (current: front, source: l.source, dir: l.dir, cost: l.cost + 1));
        }
      }

      {
        var leftDir = l.dir.turnLeft();
        var left = leftDir.add(l.current);
        if (!isWall(left)) {
          g.add(l);
          if (!seen.contains(left))
            q.addFirst(
                (current: left, source: l.current, dir: leftDir, cost: 1));
        }
      }

      {
        var rightDir = l.dir.turnRight();
        var right = rightDir.add(l.current);
        if (!isWall(right)) {
          g.add(l);
          if (!seen.contains(right))
            q.addFirst(
                (current: right, source: l.current, dir: rightDir, cost: 1));
        }
      }

      {
        if (l.current == e) {
          // We don't keep dead ends, but the exit may be one
          // so, we need to be sure to keep paths to that point
          g.add(l);
        }
      }
    }

    g.finalize();
    return g;
  }

  int dijkstra(){
    var unvisited = <(Coord, Dir)>{};
    for(int i=0; i<map.length; ++i){
      for(int j=0; j<map[i].length; ++j){
        var c = (i,j);
        if(isWall(c)) continue;
        for(var d in Dir.valids()){
          if(isWall(d.add(c))) continue;
          unvisited.add((c, d.halfTurn()));
        }
      }
    }

    int infinity = 1000 * map.length * map[0].length;
    var distances = {for (var v in unvisited) v: infinity};

    var start = (map.length - 2, 1);
    distances[(start, Dir.East)] = 0;
    unvisited.add((start, Dir.East));

    while (!unvisited.isEmpty) {
      var next = ((0, 0), Dir.None);
      var mind = infinity;
      for (var v in unvisited) {
        if (distances[v]! < mind) {
          mind = distances[v]!;
          next = v;
        }
      }
      if (mind == infinity) break; // Should not happen

      for( var d in [next.$2, next.$2.turnLeft(), next.$2.turnRight()]){
        var c = d.add(next.$1);
        if(isWall(c)) continue;

        var cost = mind + 1;
        if(d != next.$2) cost += 1000;

        var node = (c,d);
        distances[node] = min(distances[node]!, cost);
      }
      unvisited.remove(next);
    }

    var end = (1, map.length - 2);
    var endDistances = [for (var d in Dir.valids()) distances[(end, d)]??infinity];
    return endDistances.reduce(min);

  }
}

typedef MapParseRecord = ({Coord current, Coord source, Dir dir, int cost});
typedef GraphElem = (Coord, Coord);
int compareGE(GraphElem a, GraphElem b) {
  if (a.$1.$1 < b.$1.$1) return -1;
  if (a.$1.$1 > b.$1.$1) return 1;
  if (a.$1.$2 < b.$1.$2) return -1;
  if (a.$1.$2 > b.$1.$2) return 1;
  if (a.$2.$1 < b.$2.$1) return -1;
  if (a.$2.$1 > b.$2.$1) return 1;
  if (a.$2.$2 < b.$2.$2) return -1;
  if (a.$2.$2 > b.$2.$2) return 1;
  return 0;
}

class Graph {
  var graph = <GraphElem, int>{};

  void add(MapParseRecord r) {
    var e = (r.source, r.current);
    if (graph.containsKey(e)) {
      graph[e] = min(graph[e]!, r.cost);
    } else {
      graph[e] = r.cost;
    }
  }

  void finalize(){
    var keys = graph.keys.toList();
    for(var k in keys){
      graph[(k.$2, k.$1)] = graph[k]!;
    }
  }

  void display() {
    var keys = graph.keys.toList()..sort(compareGE);
    for (var k in keys) {
      print("${k.$1} => ${k.$2} ${graph[k]}");
    }
  }

  int computeShortest(Coord start, Coord end) {
    // Djisktra... The nodes are coords + direction of arrival
    var unvisited = <(Coord, Dir)>{};
    for (var e in graph.keys) {
      for(var d in Dir.valids()){
        unvisited.add((e.$1, d));
        unvisited.add((e.$2, d));
      }
    }

    int infinity = 1000 *
        (max<int>(start.$1, end.$1) - min<int>(start.$1, end.$1)) *
        (max(start.$2, end.$2) - min(start.$2, end.$2));
    var distances = {for (var v in unvisited) v: infinity};
    distances[(start, Dir.East)] = 0;

    while (!unvisited.isEmpty) {
      var next = ((0, 0), Dir.None);
      var mind = infinity;
      for (var v in unvisited) {
        if (distances[v]! < mind) {
          mind = distances[v]!;
          next = v;
        }
      }
      if (mind == infinity) break; // Should not happen

      for (var v in unvisited) {
        var e = (next.$1, v.$1);
        if (graph.containsKey(e)) {
          var cost = mind + graph[e]!;
          var dir = Dir.fromCoords(e.$1, e.$2);
          if(next.$2 != dir) cost+=1000;
          if(next.$2 == dir.halfTurn()) cost+=1000;

          var real = (v.$1, dir);
          distances[real] = min(distances[real]!, cost);
        }
      }
      unvisited.remove(next);
    }

    var endDistances = [for (var d in Dir.valids()) distances[(end, d)]!];
    return endDistances.reduce(min);
  }
}
