import 'package:day12/day12.dart';
import 'package:test/test.dart';

void main() {
  var map1 = [
    //
    "AAAA",
    "BBCD",
    "BBCC",
    "EEEC"
  ];

  var oxo = [
    //
    'OOOOO',
    'OXOXO',
    'OOOOO',
    'OXOXO',
    'OOOOO'
  ];

  var exe = [
    //
    "EEEEE",
    "EXXXX",
    "EEEEE",
    "EXXXX",
    "EEEEE"
  ];

  var abba = [
    //
    "AAAAAA",
    "AAABBA",
    "AAABBA",
    "ABBAAA",
    "ABBAAA",
    "AAAAAA"
  ];

  var large = [
    //
    'RRRRIICCFF',
    'RRRRIICCCF',
    'VVRRRCCFFF',
    'VVRCCCJFFF',
    'VVVVCJJCFE',
    'VVIVCCJJEE',
    'VVIIICJJEE',
    'MIIIIIJJEE',
    'MIIISIJEEE',
    'MMMISSJEEE'
  ];

  group('neigbours', () {
    test('map1', () {
      var zc = ZonesMap(map1);

      expect(Set.from(zc.neighbours((0, 0))), {(0, 1)});
      expect(Set.from(zc.neighbours((0, 1))), {(0, 0), (0, 2)});
      expect(Set.from(zc.neighbours((0, 2))), {(0, 1), (0, 3)});
      expect(Set.from(zc.neighbours((0, 3))), {(0, 2)});

      expect(Set.from(zc.neighbours((1, 0))), {(1, 1), (2, 0)});
      expect(Set.from(zc.neighbours((1, 1))), {(1, 0), (2, 1)});
      expect(Set.from(zc.neighbours((2, 0))), {(1, 0), (2, 1)});
      expect(Set.from(zc.neighbours((2, 1))), {(2, 0), (1, 1)});

      expect(Set.from(zc.neighbours((1, 3))), <Coords>{});

      expect(Set.from(zc.neighbours((1, 2))), {(2, 2)});
      expect(Set.from(zc.neighbours((2, 2))), {(1, 2), (2, 3)});
      expect(Set.from(zc.neighbours((2, 3))), {(2, 2), (3, 3)});
      expect(Set.from(zc.neighbours((3, 3))), {(2, 3)});

      expect(Set.from(zc.neighbours((3, 0))), {(3, 1)});
      expect(Set.from(zc.neighbours((3, 1))), {(3, 0), (3, 2)});
      expect(Set.from(zc.neighbours((3, 2))), {(3, 1)});
    });
  });

  group('Zone from coord', () {
    test('map1', () {
      var zc = ZonesMap(map1);

      expect(zc.zoneFromCoord((0, 0)), {(0, 0), (0, 1), (0, 2), (0, 3)});
      expect(zc.zoneFromCoord((0, 1)), {(0, 0), (0, 1), (0, 2), (0, 3)});
      expect(zc.zoneFromCoord((0, 2)), {(0, 0), (0, 1), (0, 2), (0, 3)});
      expect(zc.zoneFromCoord((0, 3)), {(0, 0), (0, 1), (0, 2), (0, 3)});

      expect(zc.zoneFromCoord((1, 0)), {(1, 0), (1, 1), (2, 0), (2, 1)});
      expect(zc.zoneFromCoord((1, 1)), {(1, 0), (1, 1), (2, 0), (2, 1)});
      expect(zc.zoneFromCoord((2, 0)), {(1, 0), (1, 1), (2, 0), (2, 1)});
      expect(zc.zoneFromCoord((2, 1)), {(1, 0), (1, 1), (2, 0), (2, 1)});

      expect(zc.zoneFromCoord((1, 3)), {(1, 3)});

      expect(zc.zoneFromCoord((1, 2)), {(1, 2), (2, 2), (2, 3), (3, 3)});
      expect(zc.zoneFromCoord((2, 2)), {(1, 2), (2, 2), (2, 3), (3, 3)});
      expect(zc.zoneFromCoord((2, 3)), {(1, 2), (2, 2), (2, 3), (3, 3)});
      expect(zc.zoneFromCoord((3, 3)), {(1, 2), (2, 2), (2, 3), (3, 3)});

      expect(zc.zoneFromCoord((3, 0)), {(3, 0), (3, 1), (3, 2)});
      expect(zc.zoneFromCoord((3, 1)), {(3, 0), (3, 1), (3, 2)});
      expect(zc.zoneFromCoord((3, 2)), {(3, 0), (3, 1), (3, 2)});
    });
  });

  group('zones', () {
    test('map1', () {
      expect(Set.from(ZonesMap(map1).zones()), {
        {(0, 0), (0, 1), (0, 2), (0, 3)},
        {(1, 0), (1, 1), (2, 0), (2, 1)},
        {(1, 3)},
        {(1, 2), (2, 2), (2, 3), (3, 3)},
        {(3, 0), (3, 1), (3, 2)}
      });
    });

    test('map2', () {
      expect(Set.from(ZonesMap(["AAA", "BBA", "AAA"]).zones()), {
        {(0, 0), (0, 1), (0, 2), (1, 2), (2, 0), (2, 1), (2, 2)},
        {(1, 0), (1, 1)}
      });
    });

    test('map3', () {
      expect(Set.from(ZonesMap(["ABA", "ABA", "AAA"]).zones()), {
        {(0, 0), (0, 2), (1, 0), (1, 2), (2, 0), (2, 1), (2, 2)},
        {(0, 1), (1, 1)}
      });
    });

    test('map4', () {
      expect(Set.from(ZonesMap(["AAA", "ABB", "AAA"]).zones()), {
        {(0, 0), (0, 1), (0, 2), (1, 0), (2, 0), (2, 1), (2, 2)},
        {(1, 1), (1, 2)}
      });
    });

    test('large', () {
      expect(Set.from(ZonesMap(large).zones()), {
        {
          (0, 0), (0, 1), (0, 2), (0, 3), // R
          (1, 0), (1, 1), (1, 2), (1, 3), //
          (2, 2), (2, 3), (2, 4), //
          (3, 2)
        },
        {(0, 4), (0, 5), (1, 4), (1, 5)}, // I
        {
          (0, 6), (0, 7), // C
          (1, 6), (1, 7), (1, 8), //
          (2, 5), (2, 6), //
          (3, 3), (3, 4), (3, 5), //
          (4, 4), //
          (5, 4), (5, 5), //
          (6, 5)
        },
        {
          (0, 8), (0, 9), // F
          (1, 9), //
          (2, 7), (2, 8), (2, 9), //
          (3, 7), (3, 8), (3, 9), //
          (4, 8), //
        },
        {
          (2, 0), (2, 1), // V
          (3, 0), (3, 1), //
          (4, 0), (4, 1), (4, 2), (4, 3), //
          (5, 0), (5, 1), (5, 3), //
          (6, 0), (6, 1)
        },
        {
          (3, 6), // J
          (4, 5), (4, 6), //
          (5, 6), (5, 7), //
          (6, 6), (6, 7), //
          (7, 6), (7, 7), //
          (8, 6), (9, 6)
        },
        {(4, 7)}, // C-2
        {
          (4, 9), // E
          (5, 8), (5, 9), //
          (6, 8), (6, 9), //
          (7, 8), (7, 9), //
          (8, 7), (8, 8), (8, 9), //
          (9, 7), (9, 8), (9, 9)
        },
        {
          (5, 2), // I
          (6, 2), (6, 3), (6, 4), //
          (7, 1), (7, 2), (7, 3), (7, 4), (7, 5), //
          (8, 1), (8, 2), (8, 3), (8, 5), //
          (9, 3)
        },
        {(7, 0), (8, 0), (9, 0), (9, 1), (9, 2)}, // M
        {(8, 4), (9, 4), (9, 5)} // S
      });
    });

    test('oxo', () {
      expect(Set.from(ZonesMap(oxo).zones()), {
        {
          (0, 0), (0, 1), (0, 2), (0, 3), (0, 4), //
          (1, 0), (1, 2), (1, 4), //
          (2, 0), (2, 1), (2, 2), (2, 3), (2, 4), //
          (3, 0), (3, 2), (3, 4), //
          (4, 0), (4, 1), (4, 2), (4, 3), (4, 4),
        },
        {(1, 1)},
        {(1, 3)},
        {(3, 1)},
        {(3, 3)}
      });
    });
  });

  test('point perimeter', () {
    var zc1 = ZonesMap(map1);
    expect(zc1.perimeterLengthFromCoords((0, 0)), 3);
    expect(zc1.perimeterLengthFromCoords((0, 1)), 2);
    expect(zc1.perimeterLengthFromCoords((0, 2)), 2);
    expect(zc1.perimeterLengthFromCoords((0, 3)), 3);
    expect(zc1.perimeterLengthFromCoords((1, 0)), 2);
    expect(zc1.perimeterLengthFromCoords((1, 1)), 2);
    expect(zc1.perimeterLengthFromCoords((1, 2)), 3);
    expect(zc1.perimeterLengthFromCoords((1, 3)), 4);
    expect(zc1.perimeterLengthFromCoords((2, 0)), 2);
    expect(zc1.perimeterLengthFromCoords((2, 1)), 2);
    expect(zc1.perimeterLengthFromCoords((2, 2)), 2);
    expect(zc1.perimeterLengthFromCoords((2, 3)), 2);
    expect(zc1.perimeterLengthFromCoords((3, 0)), 3);
    expect(zc1.perimeterLengthFromCoords((3, 1)), 2);
    expect(zc1.perimeterLengthFromCoords((3, 2)), 3);
    expect(zc1.perimeterLengthFromCoords((3, 3)), 3);

    var zc2 = ZonesMap(["AAA", "ABA", "AAA"]);
    expect(zc2.perimeterLengthFromCoords((1, 1)), 4);
  });

  group('count corners', () {
    test('map1', () {
      var zA = {(0, 0), (0, 1), (0, 2), (0, 3)};
      expect(cornersCountFromCoords(zA, (0, 0)), 2);
      expect(cornersCountFromCoords(zA, (0, 1)), 0);
      expect(cornersCountFromCoords(zA, (0, 2)), 0);
      expect(cornersCountFromCoords(zA, (0, 3)), 2);
      expect(cornersCountFromZone(zA), 4);

      var zB = {(1, 0), (1, 1), (2, 0), (2, 1)};
      expect(cornersCountFromCoords(zB, (1, 0)), 1);
      expect(cornersCountFromCoords(zB, (1, 1)), 1);
      expect(cornersCountFromCoords(zB, (2, 0)), 1);
      expect(cornersCountFromCoords(zB, (2, 1)), 1);
      expect(cornersCountFromZone(zB), 4);

      var zC = {(1, 2), (2, 2), (2, 3), (3, 3)};
      expect(cornersCountFromCoords(zC, (1, 2)), 2);
      expect(cornersCountFromCoords(zC, (2, 2)), 2);
      expect(cornersCountFromCoords(zC, (2, 3)), 2);
      expect(cornersCountFromCoords(zC, (3, 3)), 2);
      expect(cornersCountFromZone(zC), 8);

      var zD = {(1, 3)};
      expect(cornersCountFromCoords(zD, (1, 3)), 4);
      expect(cornersCountFromZone(zD), 4);

      var zE = {(3, 0), (3, 1), (3, 2)};
      expect(cornersCountFromCoords(zE, (3, 0)), 2);
      expect(cornersCountFromCoords(zE, (3, 1)), 0);
      expect(cornersCountFromCoords(zE, (3, 2)), 2);
      expect(cornersCountFromZone(zE), 4);
    });
  });

  test('zone data', () {
    var zs = [
      {(0, 0), (0, 1), (0, 2), (0, 3)},
      {(1, 0), (1, 1), (2, 0), (2, 1)},
      {(1, 2), (2, 2), (2, 3), (3, 3)},
      {(1, 3)},
      {(3, 0), (3, 1), (3, 2)}
    ];
    var zc1 = ZonesMap(map1);
    expect(List.from(zc1.zonesData(zs)),
        [(4, 10, 4), (4, 8, 4), (4, 10, 8), (1, 4, 4), (3, 8, 4)]);
  });

  test('cost from zone data', () {
    expect(
        fenceCostFromZoneData(
            [(4, 10, 4), (4, 8, 4), (4, 10, 8), (1, 4, 4), (3, 8, 4)]),
        (140, 80));
  });

  test('cost from map', () {
    expect(ZonesMap(map1).fenceCost(), (140, 80));
    expect(ZonesMap(oxo).fenceCost(), (772, 436));
    expect(ZonesMap(exe).fenceCost(), (692, 236));
    expect(ZonesMap(abba).fenceCost(), (1184, 368));
    expect(ZonesMap(large).fenceCost(), (1930, 1206));
  });

  group('ZoneCollector', () {
    test('add zone', () {
      var zc = ZonesCollector();
      expect(zc.zones.length, 0);
      zc.addZone({(0, 1), (2, 3)});
      expect(zc.zones.length, 1);
      zc.addZone({(4, 5), (6, 7)});
      expect(zc.zones.length, 2);
    });

    test('collected', () {
      var zc = ZonesCollector();
      zc.addZone({(0, 1), (2, 3)});
      zc.addZone({(4, 5), (6, 7)});
      expect(zc.collected((0, 1)), true);
      expect(zc.collected((6, 7)), true);
      expect(zc.collected((8, 9)), false);
    });
  });
}
