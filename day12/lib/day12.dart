import 'dart:io';

typedef Coords = (int, int);

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

  (int, int) fenceCost() {
    var zs = zones();
    var zd = zonesData(zs);
    return fenceCostFromZoneData(zd);
  }

  Iterable<Set<Coords>> zones() {
    var zc = ZonesCollector();
    for (int x = 0; x < map.length; ++x) {
      for (int y = 0; y < map[x].length; ++y) {
        if (zc.collected((x, y))) continue;
        zc.addZone(zoneFromCoord((x, y)));
      }
    }
    return zc.zones;
  }

  Set<(int, int)> zoneFromCoord(Coords seed) {
    var zone = <(int, int)>{seed};
    var stack = [seed];
    while (!stack.isEmpty) {
      var top = stack.removeLast();
      for (var n in neighbours(top)) {
        if (zone.contains(n)) continue;
        zone.add(n);
        stack.add(n);
      }
    }
    return zone;
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

  int perimeterLenghtFromZone(Set<Coords> zone) {
    return zone.fold(
        0, (acc, coords) => acc + perimeterLengthFromCoords(coords));
  }

  int perimeterLengthFromCoords(Coords coords) {
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

  Iterable<(int, int, int)> zonesData(Iterable<Set<Coords>> zones) {
    var res = <(int, int, int)>[];
    for (var zone in zones) {
      res.add((zone.length, perimeterLenghtFromZone(zone), cornersCountFromZone(zone)));
    }
    return res;
  }
}

(int, int) fenceCostFromZoneData(Iterable<(int, int, int)> data) {
  return (data.fold(0, (acc, d) => acc + d.$1 * d.$2),
          data.fold(0, (acc, d) => acc + d.$1 * d.$3));
}

int cornersCountFromZone(Set<Coords> zone) {
  return zone.fold(
      0, (acc, coords) => acc + cornersCountFromCoords(zone, coords));
}

int cornersCountFromCoords(Set<Coords> zone, Coords coords) {
  var deltas = [
    (0, -1),
    (-1, -1),
    (-1, 0),
    (-1, 1),
    (0, 1),
    (1, 1),
    (1, 0),
    (1, -1),
  ];

  var inZone =
      (delta) => zone.contains((coords.$1 + delta.$1, coords.$2 + delta.$2));
  var count = 0;
  for (int c = 0; c < 4; c++) {
    var side1 = inZone(deltas[2 * c]);
    var side2 = inZone(deltas[(2 * (c + 1)) % 8]);
    var corner = inZone(deltas[2 * c + 1]);

    if (!side1 && !side2) count++; // out corner
    if (!corner && side1 && side2) count++; // in corner
  }

  return count;
}