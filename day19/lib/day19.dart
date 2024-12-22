import 'dart:io';

(int, int) calculate(String filePath) {
  var lines = File(filePath).readAsLinesSync();
  var r = Reader.fromLines(lines);
  return r.nbValid();
}

class Reader {
  var patterns = <String>{};
  var designs = <String>[];

  Reader(this.patterns, this.designs);
  factory Reader.fromLines(List<String> lines) {
    return Reader(lines[0].split(', ').toSet(), lines.sublist(2));
  }

  (int, int) nbValid() {
    var dv = DesignValidator(patterns);
    int n = 0;
    int m = 0;
    for (var design in designs) {
      var v = dv.validCombinations(design);
      if (0 < v) n++;
      m += v;
    }
    return (n,m);
  }
}

class DesignValidator {
  var patterns = <String>{};

  DesignValidator(this.patterns);

  bool isValid(String design) {
    var offsets = [0];
    var seen = <int>{0};
    while (!offsets.isEmpty) {
      var offset = offsets.removeLast();
      seen.add(offset);
      for (var pattern in patterns) {
        var next = offset + pattern.length;
        if (seen.contains(next)) continue;
        if (!matches(design, offset, pattern)) continue;
        if (next == design.length) return true;
        offsets.add(next);
      }
    }
    return false;
  }

  int validCombinations(String design) {
    var combinationsCounts = {for (int i = 0; i <= design.length; ++i) i: 0};
    combinationsCounts[0] = 1;

    for (int offset = 0; offset < design.length; ++offset) {
      if (0 == combinationsCounts[offset]) continue; // can't reach
      for (var pattern in patterns) {
        if (!matches(design, offset, pattern)) continue;
        var nextOffset = offset + pattern.length;
        combinationsCounts[nextOffset] =
            combinationsCounts[nextOffset]! + combinationsCounts[offset]!;
      }
    }
    return combinationsCounts[design.length]!;
  }

  bool matches(String design, int offset, String pattern) {
    if (design.length < offset + pattern.length) return false;
    for (int i = 0; i < pattern.length; ++i) {
      if (design[offset + i] != pattern[i]) return false;
    }
    return true;
  }
}
