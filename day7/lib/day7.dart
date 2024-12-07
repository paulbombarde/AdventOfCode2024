import 'package:equatable/equatable.dart';
import 'dart:io';
import 'dart:convert';

typedef Operator =int Function(int,int);
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
    return _isValidRange(vals[0], 1, [add, mult]);
  }

  bool isValid2() {
    return _isValidRange(vals[0], 1, [add, mult, combine]);
  }

  bool _isValidRange(int acc, int start, List<Operator> ops) {
    if (start == vals.length) return acc == res;
    for(var op in ops){
      if (_isValidRange(op(acc, vals[start]), start + 1, ops)) {
        return true;
      }
    }
    return false;
  }

  static int combine(int high, int low){
    int f = 1;
    while(f <= low) f *= 10;
    return high * f + low;
  }

  static int add(int a, int b){
    return a + b;
  }

  static int mult(int a, int b){
    return a * b;
  }
}

class ValidSum {
  int sum1 = 0;
  int sum2 = 0;

  static Future<(int, int)> fromFile(String filePath) async {
    var v = ValidSum();
    await for (var line in readLines(filePath)) {
      v.addLine(line);
    }
    return (v.sum1, v.sum2);
  }

  static (int, int) addLines(List<String> lines) {
    var v = ValidSum();
    for (var line in lines) {
      v.addLine(line);
    }
    return (v.sum1, v.sum2);
  }

  void addLine(String line) {
    addEquation(Equation.fromLine(line));
  }

  void addEquation(Equation equation) {
    if (equation.isValid()) sum1 += equation.res;
    if (equation.isValid2()) sum2 += equation.res;
  }
}

Stream<String> readLines(String filePath) {
  final file = File(filePath);
  return file.openRead().transform(utf8.decoder).transform(LineSplitter());
}
