import 'dart:collection';
import 'dart:math';

int calculate(List<String> codes) {
  final stopwatch = Stopwatch()..start();
  var res = codes.fold(0, (sum, code) => sum + complexity(code));
  print('calculate executed in ${stopwatch.elapsed}');
  return res;
}

int calculate2(List<String> codes, int nbRobots) {
  final stopwatch = Stopwatch()..start();
  var res = codes.fold(0, (sum, code) => sum + complexity2(code, nbRobots));
  print('calculate2 executed in ${stopwatch.elapsed}');
  return res;
}

int complexity(String code, {nbRobots = 2}) {
  var c = Calculator();
  var s = c.shortests(code, nbRobots);
  var val = int.parse(code.substring(0, code.length - 1));
  return val * s.first.length;
}

int shortestLenth(Iterable<String> seqs) {
  return seqs.map((s) => s.length).reduce(min);
}

int complexity2(String code, int nbRobots) {
  var c = Calculator();
  var val = int.parse(code.substring(0, code.length - 1));
  return val * c.minLengthForCode(code, nbRobots);
}

typedef Coord = (int, int);

class Calculator {
  var keys = Pad.keys();
  var dirs = Pad.directional();

  Set<String> shortests(String code, int nbRobots) {
    var seqs = keys.shortests(code);
    for (int i = 0; i < nbRobots; ++i) {
      var tmp = dirs.allShortest(seqs);
      var l = shortestLenth(tmp);
      seqs.clear();
      for (var s in tmp) {
        if (s.length == l) seqs.add(s);
      }
    }
    return seqs;
  }

  int minLengthForCode(String code, int nbRobots) {
    var seqs = keys.shortests(code);
    if (0 == nbRobots) return seqs.first.length;
    return seqs.map((s) => minLengthForDirCode(s, nbRobots-1)).reduce(min);
  }

  int minLengthForDirCode(String code, int req) {
    var l = 0;
    var prev = "A";
    for (int i = 0; i < code.length; ++i) {
      l += minLengthForBetweenKeys(prev, code[i], req);
      prev = code[i];
    }
    return l;
  }

  var minLengthForBetweenKeysCache = <(String, String, int), int>{};
  // Warning: for codes that alternates between up/down and left/right:
  // 1. we shall not mix them
  // 2. the order matters
  // Expriments lead to that result
  final bestPathBetweenKeys = <(String, String), String>{
    ("^", "^"): "A",
    ("^", "A"): ">A",
    ("^", "<"): "v<A",
    ("^", "v"): "vA",
    ("^", ">"): "v>A",
    ("A", "^"): "<A",
    ("A", "A"): "A",
    ("A", "<"): "v<<A",
    ("A", "v"): "<vA",
    ("A", ">"): "vA",
    ("<", "^"): ">^A",
    ("<", "A"): ">>^A",
    ("<", "<"): "A",
    ("<", "v"): ">A",
    ("<", ">"): ">>A",
    ("v", "^"): "^A",
    ("v", "A"): "^>A",
    ("v", "<"): "<A",
    ("v", "v"): "A",
    ("v", ">"): ">A",
    (">", "^"): "<^A",
    (">", "A"): "^A",
    (">", "<"): "<<A",
    (">", "v"): "<A",
    (">", ">"): "A",
  };

  int minLengthForBetweenKeys(String start, String end, int req) {
    var key = (start, end, req);
    if (!minLengthForBetweenKeysCache.containsKey(key)) {
      if (req == 0) {
        minLengthForBetweenKeysCache[key] =
            bestPathBetweenKeys[(start, end)]!.length;
      } else {
        var p = bestPathBetweenKeys[(start, end)]!;
        minLengthForBetweenKeysCache[key] = minLengthForDirCode(p, req - 1);
      }
    }
    return minLengthForBetweenKeysCache[key]!;
  }
}

class Pad {
  final Map<String, Coord> pad;

  Pad(this.pad);

  // +---+---+---+
  // | 7 | 8 | 9 |
  // +---+---+---+
  // | 4 | 5 | 6 |
  // +---+---+---+
  // | 1 | 2 | 3 |
  // +---+---+---+
  //     | 0 | A |
  //     +---+---+
  Pad.keys()
      : this({
          "7": (0, 0),
          "8": (0, 1),
          "9": (0, 2),
          "4": (1, 0),
          "5": (1, 1),
          "6": (1, 2),
          "1": (2, 0),
          "2": (2, 1),
          "3": (2, 2),
          "0": (3, 1),
          "A": (3, 2)
        });

  //     +---+---+
  //     | ^ | A |
  // +---+---+---+
  // | < | v | > |
  // +---+---+---+
  Pad.directional()
      : this({
          "^": (0, 1),
          "A": (0, 2),
          "<": (1, 0),
          "v": (1, 1),
          ">": (1, 2),
        });

  Set<String> allShortest(Iterable<String> codes) {
    var seqs = <String>{};
    for (var c in codes) {
      seqs.addAll(shortests(c));
    }
    return seqs;
  }

  Set<String> shortests(String code) {
    var paths = <String>{""};
    var prev = pad["A"]!;

    for (int i = 0; i < code.length; ++i) {
      var target = pad[code[i]]!;
      var exts = shortestBetweenCoords(prev, target);

      var next = <String>{};
      for (var p in paths) {
        for (var ext in exts) {
          next.add(p + ext + "A");
        }
      }

      paths = next;
      prev = target;
    }
    return paths;
  }

  Set<String> shortestBetweenCoords(Coord start, Coord target) {
    if (start == target) return {""};

    var res = <String>{};
    var q = Queue<(Coord, String)>();
    q.addFirst((start, ""));
    while (!q.isEmpty) {
      var current = q.removeLast();
      for (var d in Dir.values) {
        if (!d.valid(current.$1, target)) continue;

        var n = d.next(current.$1);
        if (!pad.values.contains(n)) continue;

        var s = current.$2 + d.s;
        if (n == target) {
          res.add(s);
        } else {
          q.addFirst((n, s));
        }
      }
    }
    return res;
  }
}

enum Dir {
  Up(-1, 0, "^"),
  Down(1, 0, "v"),
  Left(0, -1, "<"),
  Right(0, 1, ">");

  final int x;
  final int y;
  final String s;
  const Dir(this.x, this.y, this.s);

  bool valid(Coord s, Coord t) {
    var dx = t.$1 - s.$1;
    var dy = t.$2 - s.$2;
    if (0 == dx) return 0 < dy * y;
    if (0 == dy) return 0 < dx * x;
    return 0 < dx * x || 0 < dy * y;
  }

  Coord next(Coord c) {
    return (c.$1 + x, c.$2 + y);
  }
}
