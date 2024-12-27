import 'package:day22/day22.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    var inputs = ["1", "10", "100", "2024"];
    expect(calculateFromStrings(inputs), 37327623);
  });

  test('mix', () {
    expect(mix(42, 15), 37);
  });

  test('prune', () {
    expect(prune(100000000), 16113920);
  });

  test('next secret', () {
    expect(next(123), 15887950);
    expect(next(15887950), 16495136);
    expect(next(16495136), 527345);
    expect(next(527345), 704524);
    expect(next(704524), 1553684);
    expect(next(1553684), 12683156);
    expect(next(12683156), 11100544);
    expect(next(11100544), 12249484);
    expect(next(12249484), 7753432);
    expect(next(7753432), 5908254);
  });

  test('next 2000', () {
    expect(nextIter(1, 2000), 8685429);
    expect(nextIter(10, 2000), 4700978);
    expect(nextIter(100, 2000), 15273692);
    expect(nextIter(2024, 2000), 8667524);
  });

  test('bananas', () {
//      123: 3
// 15887950: 0 (-3)
// 16495136: 6 (6)
//   527345: 5 (-1)
//   704524: 4 (-1)
//  1553684: 4 (0)
// 12683156: 6 (2)
// 11100544: 4 (-2)
// 12249484: 4 (0)
//  7753432: 2 (-2)

    var bs = bananas(123, 10);
    expect(bs, [3, 0, 6, 5, 4, 4, 6, 4, 4, 2]);
    expect(deltas(bs), {
      (-3, 6, -1, -1): 4,
      (6, -1, -1, 0): 4,
      (-1, -1, 0, 2): 6,
      (-1, 0, 2, -2): 4,
      (0, 2, -2, 0): 4,
      (2, -2, 0, -2): 2,
    });
  });

  test('one by one 1', (){
    var bs = bananas(1, 2000);
    var ds = deltas(bs);
    expect(ds[(-2,1,-1,3)], 7);
  });

  test('one by one 2', (){
    var bs = bananas(2, 2000);
    var ds = deltas(bs);
    expect(ds[(-2,1,-1,3)], 7);
  });

  test('one by one 3', (){
    var bs = bananas(3, 2000);
    var ds = deltas(bs);
    expect(ds.containsKey((-2,1,-1,3)), false);
  });

  test('one by one 2024', (){
    var bs = bananas(2024, 2000);
    var ds = deltas(bs);
    expect(ds[(-2,1,-1,3)], 9);
  });

  test('best seq', (){
    expect(bestSequence([1,2,3,2024], 2000), ((-2,1,-1,3), 23));
  });
}
