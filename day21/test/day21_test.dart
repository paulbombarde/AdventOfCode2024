import 'package:day21/day21.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(["029A", "980A", "179A", "456A", "379A"]), 126384);
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
    var n = Pad.nums();

    expect(n.shortestBetweenCoords((0,1), (0,1)), {""});

    var s = n.shortests("<A^A>^^AvvvA");
    expect(s.contains("v<<A>>^A<A>AvA<^AA>A<vAAA>^A"), true);
  });
}
