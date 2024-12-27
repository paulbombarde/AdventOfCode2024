import 'package:day22/day22.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    var inputs = ["1", "10", "100", "2024"];
    expect(calculateFromStrings(inputs), 37327623);
  });

  test('mix', (){
    expect(mix(42,15), 37);
  });

  test('prune', (){
    expect(prune(100000000), 16113920);
  });

  test('next secret', (){
    var g = SecretGenerator();

    expect(g.next(123), 15887950);
    expect(g.next(15887950), 16495136);
    expect(g.next(16495136), 527345);
    expect(g.next(527345), 704524);
    expect(g.next(704524), 1553684);
    expect(g.next(1553684), 12683156);
    expect(g.next(12683156), 11100544);
    expect(g.next(11100544), 12249484);
    expect(g.next(12249484), 7753432);
    expect(g.next(7753432), 5908254);
  });

  test('next 2000', (){
    var g = SecretGenerator();
    expect(g.nextIter(1, 2000), 8685429);
    expect(g.nextIter(10, 2000), 4700978);
    expect(g.nextIter(100, 2000), 15273692);
    expect(g.nextIter(2024, 2000), 8667524);
  });
}
