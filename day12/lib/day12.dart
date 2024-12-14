import 'dart:io';

typedef Coords = (int, int);
/*
Iterable<Set<Coords>> computeZones(List<String> map) {
  var coordsToZone = <List<int>>[];
  var connections = <int, int>{};

  int latestZoneId = 0;
  for (int i = 0; i < map.length; ++i) {
    var coordsToZoneLine = <int>[];
    for (int j = 0; j < map[i].length; ++j) {
      if (0 < i && map[i - 1][j] == map[i][j]) {
        coordsToZoneLine.add(coordsToZone[i - 1][j]);
        if (0 < j &&
            map[i][j - 1] == map[i][j] &&
            coordsToZoneLine[j] != coordsToZoneLine[j - 1]) {
          if (connections.containsKey(coordsToZoneLine[j])) {
            connections[coordsToZoneLine[j - 1]] =
                connections[coordsToZoneLine[j]]!;
          } else {
            connections[coordsToZoneLine[j - 1]] = coordsToZoneLine[j];
          }
        }
        continue;
      }
      if (0 < j && map[i][j - 1] == map[i][j]) {
        coordsToZoneLine.add(coordsToZoneLine[j - 1]);
        continue;
      }
      coordsToZoneLine.add(latestZoneId++);
    }
    coordsToZone.add(coordsToZoneLine);
  }

  var res = <int, Set<Coords>>{};
  for (int i = 0; i < map.length; ++i) {
    for (int j = 0; j < map[i].length; ++j) {
      var realZoneId = coordsToZone[i][j];
      if (connections.containsKey(realZoneId)) {
        realZoneId = connections[realZoneId]!;
      }

      if (!res.containsKey(realZoneId)) {
        res[realZoneId] = {};
      }
      res[realZoneId]!.add((i, j));
    }
  }

  for (var e in res.entries) {
    var debug_file = File("Debug-${e.key}.txt").openWrite();
    for (int i = 0; i < map.length; ++i) {
      for (int j = 0; j < map[i].length; ++j) {
        if (e.value.contains((i, j)))
          debug_file.write(map[i][j]);
        else
          debug_file.write(' ');
      }
      debug_file.write('\n');
    }
  }
  return res.values;
}
*/

class ZonesCollector {
  var zones = <Set<Coords>>[];

  void addZone(Set<Coords> zone) {
    zones.add(zone);
  }

  bool collected(Coords c) {
    for (var zone in zones) {
      if (zone.contains(c)) return true;
    }
    return false;
  }
}

class ZonesMap {
  final List<String> map;

  ZonesMap(this.map);
  ZonesMap.fromFile(String filePath) : this(File(filePath).readAsLinesSync());

  int perimeter(Coords coords) {
    var p = 0;
    if (0 == coords.$1 ||
        map[coords.$1 - 1][coords.$2] != map[coords.$1][coords.$2]) p++;
    if (0 == coords.$2 ||
        map[coords.$1][coords.$2 - 1] != map[coords.$1][coords.$2]) p++;
    if (coords.$1 == map.length - 1 ||
        map[coords.$1 + 1][coords.$2] != map[coords.$1][coords.$2]) p++;
    if (coords.$2 == map[0].length - 1 ||
        map[coords.$1][coords.$2 + 1] != map[coords.$1][coords.$2]) p++;
    return p;
  }

  Iterable<Coords> neighbours(Coords coords) {
    var res = <Coords>[];
    var v = map[coords.$1][coords.$2];

    if (0 < coords.$1 && map[coords.$1 - 1][coords.$2] == v)
      res.add((coords.$1 - 1, coords.$2));
      
    if (0 < coords.$2 && map[coords.$1][coords.$2 - 1] == v)
      res.add((coords.$1, coords.$2 - 1));

    if (coords.$1 < map.length - 1 && map[coords.$1 + 1][coords.$2] == v)
      res.add((coords.$1 + 1, coords.$2));

    if (coords.$2 < map[0].length - 1 && map[coords.$1][coords.$2 + 1] == v)
      res.add((coords.$1, coords.$2 + 1));

    return res;
  }

  Set<(int, int)> zoneFromCoord(Coords seed) {
    var zone = <(int, int)>{seed};
    var stack = [seed];
    while (!stack.isEmpty) {
      var top = stack.removeLast();
      for( var n in neighbours(top)) {
        if(zone.contains(n)) continue;
        zone.add(n);
        stack.add(n);
      }
    }
    return zone;
  }

  Iterable<Set<Coords>> zones(){
    var zc = ZonesCollector();
    for(int x = 0; x<map.length; ++x){
      for(int y = 0; y<map[x].length; ++y){
        if(zc.collected((x,y))) continue;
        zc.addZone(zoneFromCoord((x,y)));
      }
    }
    return zc.zones;
  }

  Iterable<(int, int)> zonesData(Iterable<Set<Coords>> zones) {
    var res = <(int, int)>[];
    for (var zone in zones) {
      var p = zone.fold(0, (acc, coords) => acc + perimeter(coords));
      res.add((p, zone.length));
    }
    return res;
  }


  int fenceCost() {
    var zs = zones();
    var zd = zonesData(zs);
    return fenceCostFromZoneData(zd);
  }
}

int fenceCostFromZoneData(Iterable<(int, int)> data) {
  return data.fold(0, (acc, d) => acc + d.$1 * d.$2);
}
  

/*
Iterable<Set<Coords>> computeZones(List<String> map) {
  var coordsToZone = <List<int>>[];
  var connections = <int, int>{};

  int latestZoneId = 0;
  for (int i = 0; i < map.length; ++i) {
    var coordsToZoneLine = <int>[];
    for (int j = 0; j < map[i].length; ++j) {
      if (0 < i && map[i - 1][j] == map[i][j]) {
        coordsToZoneLine.add(coordsToZone[i - 1][j]);
        if (0 < j &&
            map[i][j - 1] == map[i][j] &&
            coordsToZoneLine[j] != coordsToZoneLine[j - 1]) {
          if (connections.containsKey(coordsToZoneLine[j])) {
            connections[coordsToZoneLine[j - 1]] =
                connections[coordsToZoneLine[j]]!;
          } else {
            connections[coordsToZoneLine[j - 1]] = coordsToZoneLine[j];
          }
        }
        continue;
      }
      if (0 < j && map[i][j - 1] == map[i][j]) {
        coordsToZoneLine.add(coordsToZoneLine[j - 1]);
        continue;
      }
      coordsToZoneLine.add(latestZoneId++);
    }
    coordsToZone.add(coordsToZoneLine);
  }

  var res = <int, Set<Coords>>{};
  for (int i = 0; i < map.length; ++i) {
    for (int j = 0; j < map[i].length; ++j) {
      var realZoneId = coordsToZone[i][j];
      if (connections.containsKey(realZoneId)) {
        realZoneId = connections[realZoneId]!;
      }

      if (!res.containsKey(realZoneId)) {
        res[realZoneId] = {};
      }
      res[realZoneId]!.add((i, j));
    }
  }

  for (var e in res.entries) {
    var debug_file = File("Debug-${e.key}.txt").openWrite();
    for (int i = 0; i < map.length; ++i) {
      for (int j = 0; j < map[i].length; ++j) {
        if (e.value.contains((i, j)))
          debug_file.write(map[i][j]);
        else
          debug_file.write(' ');
      }
      debug_file.write('\n');
    }
  }
  return res.values;
}
*/
