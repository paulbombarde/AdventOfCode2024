import 'dart:io';
import 'dart:convert';

Future<int> multsSumFromFile(String filePath) async {
  var lines = readLines(filePath);
  var mults = readAllMults(lines);
  return multsSum(mults);
}

Future<int> multsSumFromFile2(String filePath) async {
  var lines = readLines(filePath);
  var slines = splitLines(lines);
  var mults = readAllMults(slines);
  return multsSum(mults);
}

Stream<(int, int)> readAllMults(Stream<String> lines) async* {
  await for (var line in lines) {
    await for (final m in readMults(line)) {
      yield m;
    }
  }
}

Stream<(int, int)> readMults(String line) async* {
  var multRe = RegExp(r'mul\((\d{1,3}),(\d{1,3})\)');
  for (final m in multRe.allMatches(line)) {
    yield (int.parse(m[1]!), int.parse(m[2]!));
  }
}

Stream<String> splitLines(Stream<String> lines) async* {
  var splitRe = RegExp(r"do\(\)|don't\(\)");
  var active = true;
  await for (final line in lines) {
    var start = 0;
    for (final m in splitRe.allMatches(line)) {
      if (active) {
        yield line.substring(start, m.start);
      }
      if (m[0] == "do()") {
        active = true;
        start = m.start + 4;
      } else {
        active = false;
      }
    }
    if (active && start != line.length) {
      yield line.substring(start);
    }
  }
}

Future<int> multsSum(Stream<(int, int)> mults) async {
  return mults.fold(0, (a, m) => a + m.$1 * m.$2);
}

Stream<String> readLines(String filePath) {
  final file = File(filePath);
  return file.openRead().transform(utf8.decoder).transform(LineSplitter());
}
