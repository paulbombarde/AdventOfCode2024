import 'dart:collection';
import 'dart:math';

int calculate(List<String> codes) {
  return codes.fold(0, (sum, code) => sum + complexity(code));
}

int complexity(String code) {
  var keys = Pad.keys();
  var nums = Pad.nums();

  var seqs0 = {code};
  var seqs1 = keys.allShortest(seqs0);
  var seqs2 = nums.allShortest(seqs1);
  var seqs3 = nums.allShortest(seqs2);

  var minLength = 10000000000;
  for(var s in seqs3){
    minLength = min(minLength, s.length);
  }

  var val = int.parse(code.substring(0, code.length-1));

  return val * minLength;
}

typedef Coord = (int, int);

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
  Pad.nums()
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
