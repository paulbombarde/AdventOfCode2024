import 'dart:io';
import 'dart:convert';

Future<(int, int)> minTokensFromFile(String filePath) async {
  var lines = readLines(filePath);
  var machines = machinesFromLines(lines);
  return pricesFromMachines(machines);
}

class Machine {
  int A1 = 0;
  int A2 = 0;
  int B1 = 0;
  int B2 = 0;
  int X = 0;
  int Y = 0;

  Machine(this.A1, this.A2, this.B1, this.B2, this.X, this.Y);
  Machine.fromLines(List<String> lines) {
    var readFactors = (String line) {
      var e0 = line.split(":");
      var e1 = e0[1].split(" ");
      var a1 = e1[1].substring(2, e1[1].length - 1);
      var a2 = e1[2].substring(2);
      return (int.parse(a1), int.parse(a2));
    };

    var a = readFactors(lines[0]);
    var b = readFactors(lines[1]);
    var r = readFactors(lines[2]);

    this.A1 = a.$1;
    this.A2 = a.$2;
    this.B1 = b.$1;
    this.B2 = b.$2;
    this.X = r.$1;
    this.Y = r.$2;
  }

  bool operator ==(Object other) {
    return other is Machine &&
        other.A1 == A1 &&
        other.A2 == A2 &&
        other.B1 == B1 &&
        other.B2 == B2 &&
        other.X == X &&
        other.Y == Y;
  }

  (int, int) solve({int delta = 0}) {
    // A1*n + B1*m = X+d
    // A2*n + B2*m = Y+d

    // A2*A1*n + A2*B1*m = A2*(X+d)
    // A1*A2*n + A1*B2*m = A1*(Y+d)
    // &&
    // B2*A1*n + B2*B1*m = B2*(X+d)
    // B1*A2*n + B1*B2*m = B1*(Y+d)

    // (B1*A2 - B2*A1)*m = A2*(X+d) - A1*(Y+d)
    // (B2*A1 - B1*A2)*n = B2*(X+d) - B1*(Y+d)
    var Fm = B1 * A2 - B2 * A1;
    var Rm = A2 * (delta + X) - A1 * (delta + Y);

    var Fn = B2 * A1 - B1 * A2;
    var Rn = B2 * (delta + X) - B1 * (delta + Y);
    if (0 != Rn % Fn || 0 != Rm % Fm) return (0, 0);
    return (Rn ~/ Fn, Rm ~/ Fm);
  }

  int price({int delta = 0}) {
    var s = solve(delta: delta);
    return 3 * s.$1 + s.$2;
  }
}

Stream<Machine> machinesFromLines(Stream<String> lines) async* {
  var buffer = <String>[];
  await for (var line in lines) {
    if (line.length == 0) {
      yield Machine.fromLines(buffer);
      buffer.clear();
      continue;
    }
    buffer.add(line);
  }
  if (0 < buffer.length) {
    yield Machine.fromLines(buffer);
  }
}

Future<(int, int)> pricesFromMachines(Stream<Machine> machines) async {
  var d = 10000000000000;
  return machines.fold(
      (0, 0), (acc, m) => (acc.$1 + m.price(), acc.$2 + m.price(delta: d)));
}

Stream<String> readLines(String filePath) {
  final file = File(filePath);
  return file.openRead().transform(utf8.decoder).transform(LineSplitter());
}
