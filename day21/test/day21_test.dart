import 'package:day21/day21.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(["029A", "980A", "179A", "456A", "379A"]), 126384);
    expect(calculate2(["029A", "980A", "179A", "456A", "379A"], 2), 126384);
    expect(calculate2(["029A", "980A", "179A", "456A", "379A"], 25), 154115708116294);
  });

  test('shortests keys', (){
    var p = Pad.keys();

    expect(p.shortestBetweenCoords((3,2), (3,1)), {"<"});
    expect(p.shortestBetweenCoords((3,1), (2,1)), {"^"});
    expect(p.shortestBetweenCoords((2,1), (0,2)), {"^^>", "^>^", ">^^"});
    
    expect(p.shortests("029A"), <String>{
      "<A^A>^^AvvvA", "<A^A^>^AvvvA", "<A^A^^>AvvvA"
    });
  });

  test('shortest nums', (){
    var n = Pad.directional();

    expect(n.shortestBetweenCoords((0,1), (0,1)), {""});

    var s = n.shortests("<A^A>^^AvvvA");
    expect(s.contains("v<<A>>^A<A>AvA<^AA>A<vAAA>^A"), true);
  });

  test('minLength', (){
    var c = Calculator();
    // The references for depths 25 got cheated thanks to
    // https://www.reddit.com/r/adventofcode/comments/1hjb7hh/comment/m354hxk/

    expect(shortestLenth(c.shortests("029A", 0)), 12);
    expect(c.minLengthForCode("029A", 0), 12);
    expect(shortestLenth(c.shortests("029A", 1)), 28);
    expect(c.minLengthForCode("029A", 1), 28);
    expect(shortestLenth(c.shortests("029A", 2)), 68);
    expect(c.minLengthForCode("029A", 2), 68);
    expect(c.minLengthForCode("029A", 25), 82050061710);

    expect(shortestLenth(c.shortests("980A", 0)), 12);
    expect(c.minLengthForCode("980A", 0), 12);
    expect(shortestLenth(c.shortests("980A", 1)), 26);
    expect(c.minLengthForCode("980A", 1), 26);
    expect(shortestLenth(c.shortests("980A", 2)), 60);
    expect(c.minLengthForCode("980A", 2), 60);
    expect(c.minLengthForCode("980A", 25), 72242026390);

    expect(shortestLenth(c.shortests("179A", 0)), 14);
    expect(c.minLengthForCode("179A", 0), 14);
    expect(shortestLenth(c.shortests("179A", 1)), 28);
    expect(c.minLengthForCode("179A", 1), 28);
    expect(shortestLenth(c.shortests("179A", 2)), 68);
    expect(c.minLengthForCode("179A", 2), 68);
    expect(c.minLengthForCode("179A", 25), 81251039228);

    expect(shortestLenth(c.shortests("456A", 0)), 12);
    expect(c.minLengthForCode("456A", 0), 12);
    expect(shortestLenth(c.shortests("456A", 1)), 26);
    expect(c.minLengthForCode("456A", 1), 26);
    expect(shortestLenth(c.shortests("456A", 2)), 64);
    expect(c.minLengthForCode("456A", 2), 64);
    expect(c.minLengthForCode("456A", 25), 80786362258);

    expect(shortestLenth(c.shortests("379A", 0)), 14);
    expect(c.minLengthForCode("379A", 0), 14);
    expect(shortestLenth(c.shortests("379A", 1)), 28);
    expect(c.minLengthForCode("379A", 1), 28);
    expect(shortestLenth(c.shortests("379A", 2)), 64);
    expect(c.minLengthForCode("379A", 2), 64);
    expect(c.minLengthForCode("379A", 25), 77985628636);
  });
}
