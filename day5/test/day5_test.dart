import 'package:day5/day5.dart';
import 'package:test/test.dart';

void main() {
  var mapLines = [
    "47|53",
    "97|13",
    "97|61",
    "97|47",
    "75|29",
    "61|13",
    "75|53",
    "29|13",
    "97|29",
    "53|29",
    "61|53",
    "97|53",
    "61|29",
    "47|13",
    "75|47",
    "97|75",
    "47|61",
    "75|61",
    "47|29",
    "75|13",
    "53|13",
  ];

  var sampleMap = {
    97: {13, 61, 47, 29, 53, 75},
    75: {29, 53, 47, 61, 13},
    47: {53, 13, 61, 29},
    61: {13, 53, 29},
    53: {29, 13},
    29: {13}
  };

  group("Comparator", () {
    test('comparator add rule', () {
      var rules = [
        (47, 53),
        (97, 13),
        (97, 61),
        (97, 47),
        (75, 29),
        (61, 13),
        (75, 53),
        (29, 13),
        (97, 29),
        (53, 29),
        (61, 53),
        (97, 53),
        (61, 29),
        (47, 13),
        (75, 47),
        (97, 75),
        (47, 61),
        (75, 61),
        (47, 29),
        (75, 13),
        (53, 13),
      ];

      var c = Comparator();
      for (var r in rules) {
        c.addRule(r.$1, r.$2);
      }

      expect(c.rules, sampleMap);
    });

    test('builds map', () {
      var c = Comparator();
      c.addRulesFromStrings(mapLines);
      expect(c.rules, sampleMap);
    });

    test('validates update', () {
      var c = Comparator();
      c.addRulesFromStrings(mapLines);

      expect(c.validate([75, 47, 61, 53, 29]), true);
      expect(c.validate([97, 61, 53, 29, 13]), true);
      expect(c.validate([75, 29, 13]), true);
      expect(c.validate([75, 97, 47, 61, 53]), false);
      expect(c.validate([61, 13, 29]), false);
      expect(c.validate([97, 13, 75, 29, 47]), false);
    });
  });

  test('Parse record', () {
    expect(updateFromString("75,47,61,53,29"), [75, 47, 61, 53, 29]);
    expect(updateFromString("97,61,53,29,13"), [97, 61, 53, 29, 13]);
    expect(updateFromString("75,29,13"), [75, 29, 13]);
    expect(updateFromString("75,97,47,61,53"), [75, 97, 47, 61, 53]);
    expect(updateFromString("61,13,29"), [61, 13, 29]);
    expect(updateFromString("97,13,75,29,47"), [97, 13, 75, 29, 47]);
  });

  test('update middle', () {
    expect(middle([75, 47, 61, 53, 29]), 61);
    expect(middle([97, 61, 53, 29, 13]), 53);
    expect(middle([75, 29, 13]), 29);
    expect(middle([75, 97, 47, 61, 53]), 47);
    expect(middle([61, 13, 29]), 13);
    expect(middle([97, 13, 75, 29, 47]), 75);
  });

  test('fix updates', () {
    var c = Comparator();
    c.addRulesFromStrings(mapLines);

    expect(c.fix([75, 47, 61, 53, 29]), [75, 47, 61, 53, 29]);
    expect(c.fix([97, 61, 53, 29, 13]), [97, 61, 53, 29, 13]);
    expect(c.fix([75, 29, 13]), [75, 29, 13]);
    expect(c.fix([75, 97, 47, 61, 53]), [97, 75, 47, 61, 53]);
    expect(c.fix([61, 13, 29]), [61, 29, 13]);
    expect(c.fix([97, 13, 75, 29, 47]), [97, 75, 47, 29, 13]);
  });

  test('sum of middles', () {
    var lines = [
      "47|53",
      "97|13",
      "97|61",
      "97|47",
      "75|29",
      "61|13",
      "75|53",
      "29|13",
      "97|29",
      "53|29",
      "61|53",
      "97|53",
      "61|29",
      "47|13",
      "75|47",
      "97|75",
      "47|61",
      "75|61",
      "47|29",
      "75|13",
      "53|13",
      "",
      "75,47,61,53,29",
      "97,61,53,29,13",
      "75,29,13",
      "75,97,47,61,53",
      "61,13,29",
      "97,13,75,29,47"
    ];

    expect(sumOfMiddles(lines), (143, 123));
  });
}
