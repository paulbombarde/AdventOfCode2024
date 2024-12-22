import 'package:day19/day19.dart';
import 'package:test/test.dart';

void main() {
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

  test('validCombinations', (){
    var dv = DesignValidator({"r", "wr", "b", "g", "bwu", "rb", "gb", "br"});

    expect(dv.validCombinations("brwrr"), 2);
    expect(dv.validCombinations("bggr"), 1);
    expect(dv.validCombinations("gbbr"), 4);
    expect(dv.validCombinations("rrbgbr"), 6);
    expect(dv.validCombinations("ubwu"), 0);
    expect(dv.validCombinations("bwurrg"), 1);
    expect(dv.validCombinations("brgr"), 2);
    expect(dv.validCombinations("bbrgwb"), 0);
  });
}
