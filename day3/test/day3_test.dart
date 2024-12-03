import 'package:day3/day3.dart';
import 'package:test/test.dart';

void main() {
  test('generates valid mults from line', () {
    var line =
        'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))';
    var mults = [(2, 4), (5, 5), (11, 8), (8, 5)];
    expect(readMults(line).toList().then((v) => expect(v, mults)), completes);
  });

  test('split lines with cond', () {
    var lines = [
      "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)",
      '+mul(32,64]then(mul(11,8)do()?mul(8,5))'
    ];
    var mults = ["xmul(2,4)&mul[3,7]!^", "?mul(8,5))"];
    expect(
        splitLines(Stream.fromIterable(lines))
            .toList()
            .then((v) => expect(v, mults)),
        completes);
  });

  test('computes mults sum', () {
    var mults = [(2, 4), (5, 5), (11, 8), (8, 5)];
    expect(multsSum(Stream.fromIterable(mults)).then((v) => expect(v, 161)),
        completes);
  });

  test('generates mults from line stream', () {
    var lines = [
      'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)',
      '+mul(32,64]then(mul(11,8)mul(8,5))'
    ];
    var mults = [(2, 4), (5, 5), (11, 8), (8, 5)];
    expect(
        readAllMults(Stream.fromIterable(lines))
            .toList()
            .then((v) => expect(v, mults)),
        completes);
  });
}
