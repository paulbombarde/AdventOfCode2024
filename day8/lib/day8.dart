import 'dart:io';

typedef Mapp = List<String>;
typedef Point = (int, int);
typedef Antennas = Map<String, List<Point>>;

(int, int) antinodesCountFromFile(String filePath){
  var map = File(filePath).readAsLinesSync();
  var antennas = antennasPerFreq(map);
  var antinodes = antinodesForFreqAntennas(map, antennas);
  var allAntinodes = allAntinodesForFreqAntennas(map, antennas);

  return (antinodesCount(antinodes), antinodesCount(allAntinodes));
}

Antennas antennasPerFreq(Mapp map) {
  var res = <String, List<Point>>{};
  for (int x = 0; x < map.length; ++x) {
    for (int y = 0; y < map[x].length; ++y) {
      if (map[x][y] == ".") continue;
      if (!res.containsKey(map[x][y])) res[map[x][y]] = [];
      res[map[x][y]]!.add((x, y));
    }
  }
  return res;
}

bool pointInMap(Mapp map, Point p){
  return coordsInMap(map, p.$1, p.$2);
}

bool coordsInMap(Mapp map, int x, int y){
    return 0<=x && x<map.length && 0<=y && y<map[0].length;

}

Point addCoords(Point p, int dx, int dy){
  return (p.$1 + dx, p.$2 + dy);
}

Set<Point> antinodesForAntennas(Mapp map, List<Point> antennas) {
  var res = <Point>{};
  for(int i=0; i<antennas.length; ++i){
    for(int j=i+1; j<antennas.length; ++j){
      var dx = antennas[i].$1 - antennas[j].$1;
      var dy = antennas[i].$2 - antennas[j].$2;
      var p1 = addCoords(antennas[i], dx, dy);
      var p2 = addCoords(antennas[j], -dx, -dy);
      if(pointInMap(map, p1)) res.add(p1);
      if(pointInMap(map, p2)) res.add(p2);
    }
  }
  return res;
}

Set<Point> allAntinodesForAntennas(Mapp map, List<Point> antennas) {
  var res = <Point>{};
  for(int i=0; i<antennas.length; ++i){
    for(int j=i+1; j<antennas.length; ++j){
      var dx = antennas[i].$1 - antennas[j].$1;
      var dy = antennas[i].$2 - antennas[j].$2;

      var p1 = (antennas[i].$1, antennas[i].$2);
      while(pointInMap(map, p1))
      {
        res.add(p1);
        p1 = addCoords(p1, dx, dy);
      }

      p1 = (antennas[j].$1, antennas[j].$2);
      while(pointInMap(map, p1))
      {
        res.add(p1);
        p1 = addCoords(p1, -dx, -dy);
      }
    }
  }
  return res;
}

Map<String, Set<Point>> antinodesForMap(Mapp map){
  var antennas = antennasPerFreq(map);
  return antinodesForFreqAntennas(map, antennas);
}

Map<String, Set<Point>> antinodesForFreqAntennas(Mapp map, Antennas antennas){
  return { for(var e in antennas.entries) e.key: antinodesForAntennas(map, e.value)};
}

Map<String, Set<Point>> allAntinodesForFreqAntennas(Mapp map, Antennas antennas){
  return { for(var e in antennas.entries) e.key: allAntinodesForAntennas(map, e.value)};
}

int antinodesCount(Map<String, Set<Point>> antinodes)
{
  var res = <Point>{};
  for(var v in antinodes.values) res.addAll(v);
  return res.length;
}
