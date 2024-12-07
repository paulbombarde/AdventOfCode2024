import 'package:equatable/equatable.dart';
import 'dart:io';
import 'dart:convert';

class Equation extends Equatable {
  final int res;
  final List<int> vals;

  Equation(this.res, this.vals);

  @override
  List<Object?> get props => [res, vals];

  static Equation fromLine(String line) {
    var split = line.split(" ");
    return Equation(int.parse(split[0].substring(0, split[0].length - 1)),
        [for (int i = 1; i < split.length; ++i) int.parse(split[i])]);
  }

  bool isValid() {
    return _isValidRange(vals[0], 1);
  }

  bool _isValidRange(int acc, int start) {
    if (start == vals.length) return acc == res;
    if (_isValidRange(acc + vals[start], start + 1)) return true;
    if (_isValidRange(acc * vals[start], start + 1)) return true;
    return false;
  }
}

class ValidSum {
  int sum = 0;

  static Future<int> fromFile(String filePath) async {
    var v = ValidSum();
    await for (var line in readLines(filePath)) {
      v.addLine(line);
    }
    return v.sum;
  }

  static int addLines(List<String> lines) {
    var v = ValidSum();
    for (var line in lines) {
      v.addLine(line);
    }
    return v.sum;
  }

  void addLine(String line) {
    addEquation(Equation.fromLine(line));
  }

  void addEquation(Equation equation) {
    if (equation.isValid()) sum += equation.res;
  }
}

Stream<String> readLines(String filePath) {
  final file = File(filePath);
  return file.openRead().transform(utf8.decoder).transform(LineSplitter());
}
