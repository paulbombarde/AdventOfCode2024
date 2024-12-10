import 'package:day10/day10.dart';
import 'package:test/test.dart';

void main() {
  test('Topo from strings', () {
    var topo = Topo.fromStrings(["0123", "1234", "8765", "9876"]);
    expect(topo.map, [
      [0, 1, 2, 3],
      [1, 2, 3, 4],
      [8, 7, 6, 5],
      [9, 8, 7, 6]
    ]);
  });

  test('start points', () {
    var topo = Topo([
      [0, 1, 2, 3],
      [1, 0, 3, 4],
      [8, 7, 6, 5],
      [9, 8, 7, 6]
    ]);
    expect(topo.heads(), {(0, 0), (1, 1)});
  });

  test('next points', () {
    var topo = Topo([
      [0, 1, 2, 3],
      [1, 0, 3, 4],
      [8, 7, 6, 5],
      [9, 8, 7, 6]
    ]);

    expect(topo.next((0, 0)), {(1, 0), (0, 1)});
    expect(topo.next((1, 0)), {});
    expect(topo.next((2, 0)), {(3, 0)});
    expect(topo.next((3, 0)), {});

    expect(topo.next((0, 1)), {(0, 2)});
    expect(topo.next((1, 1)), {});
    expect(topo.next((2, 1)), {(2, 0), (3, 1)});
    expect(topo.next((3, 1)), {(3, 0)});

    expect(topo.next((0, 2)), {(0, 3), (1, 2)});
    expect(topo.next((1, 2)), {(1, 3)});
    expect(topo.next((2, 2)), {(2, 1), (3, 2)});
    expect(topo.next((3, 2)), {(3, 1)});

    expect(topo.next((0, 3)), {(1, 3)});
    expect(topo.next((1, 3)), {(2, 3)});
    expect(topo.next((2, 3)), {(2, 2), (3, 3)});
    expect(topo.next((3, 3)), {(3, 2)});
  });

    var topo = Topo.fromStrings([
      "89010123",
      "78121874",
      "87430965",
      "96549874",
      "45678903",
      "32019012",
      "01329801",
      "10456732"
    ]);


  test('trail head score', () {
    expect(topo.computeTrailHeadScore((0, 2)), (5, 20));
    expect(topo.computeTrailHeadScore((0, 4)), (6, 24));
    expect(topo.computeTrailHeadScore((2, 4)), (5, 10));
    expect(topo.computeTrailHeadScore((4, 6)), (3, 4));
    expect(topo.computeTrailHeadScore((5, 2)), (1, 1));
    expect(topo.computeTrailHeadScore((5, 5)), (3, 4));
    expect(topo.computeTrailHeadScore((6, 0)), (5, 5));
    expect(topo.computeTrailHeadScore((6, 6)), (3, 8));
    expect(topo.computeTrailHeadScore((7, 1)), (5, 5));
  });

  test('map score', () {
    expect(topo.computeMapScore(), (36, 81));
  });

  test('map score parallel', () async {
    var res = await topo.computeMapScoreParallel();
    expect(res, (36, 81));
  });
}
