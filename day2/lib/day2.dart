import 'dart:io';
import 'dart:convert';

Future<int> safeCountFromFile(String filePath, bool safeTest(List<int> l)) async {
  var lines = readLines(filePath);
  var reports = parseReports(lines);
  return safeCount(reports, safeTest);
}

Future<int> safeCount(Stream<List<int>> reports, bool safeTest(List<int> l)) async {
  return reports.where(safeTest).length;
}

bool isSafe(List<int> l) {
  if (l.length < 2) {
    return true;
  }

  var inc = (l[0] < l[1]) ? 1 : -1;
  for (int i = 1; i < l.length; ++i) {
    var d = inc * (l[i] - l[i - 1]);
    if (d < 1 || 3 < d) {
      return false;
    }
  }

  return true;
}

bool isSafe2(List<int> l) {
  if (l.length < 2) {
    return true;
  }

  if(isSafe(l)) {
    return true;
  }

  for (int i=0; i<l.length; ++i) {
    var dampended = <int>[];
    for (int j=0; j<l.length; ++j){
      if(i == j) continue;
      dampended.add(l[j]);
    }

    if(isSafe(dampended)) {
      return true;
    }
  }

  return false;
}

Stream<List<int>> parseReports(Stream<String> reports) {
  return reports.map(parseReport);
}

List<int> parseReport(String report) {
  return [for (var i in report.split(' ')) int.parse(i)];
}

Stream<String> readLines(String filePath) {
  final file = File(filePath);
  return file.openRead().transform(utf8.decoder).transform(LineSplitter());
}
