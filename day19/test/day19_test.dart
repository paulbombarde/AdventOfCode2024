import 'package:day19/day19.dart';
import 'package:test/test.dart';

void main() {
  var sample = [
    "r, wr, b, g, bwu, rb, gb, br",
    "",
    "brwrr",
    "bggr",
    "gbbr",
    "rrbgbr",
    "ubwu",
    "bwurrg",
    "brgr",
    "bbrgwb"
  ];

  test('isValid', () {
    var dv = DesignValidator({"r", "wr", "b", "g", "bwu", "rb", "gb", "br"});

    expect(dv.isValid("brwrr"), true);
    expect(dv.isValid("bggr"), true);
    expect(dv.isValid("gbbr"), true);
    expect(dv.isValid("rrbgbr"), true);
    expect(dv.isValid("ubwu"), false);
    expect(dv.isValid("bwurrg"), true);
    expect(dv.isValid("brgr"), true);
    expect(dv.isValid("bbrgwb"), false);
  });
}
