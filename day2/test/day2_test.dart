import 'package:day2/day2.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

void main() {
  test('report safety', () {
    expect(isSafe([7, 6, 4, 2, 1]), true);
    expect(isSafe([1, 2, 4, 6, 7]), true);
    expect(isSafe([1, 3, 6, 7, 9]), true);
    expect(isSafe([9, 7, 6, 3, 1]), true);

    expect(isSafe([1, 2, 7, 8, 9]), false);
    expect(isSafe([9, 7, 6, 2, 1]), false);
    expect(isSafe([1, 3, 2, 4, 5]), false);
    expect(isSafe([8, 6, 4, 4, 1]), false);
  });

  test('report safety with dampener', () {
    expect(isSafe2([7, 6, 4, 2, 1]), true);
    expect(isSafe2([1, 2, 4, 6, 7]), true);
    expect(isSafe2([1, 3, 6, 7, 9]), true);
    expect(isSafe2([9, 7, 6, 3, 1]), true);

    expect(isSafe2([1, 2, 7, 8, 9]), false);
    expect(isSafe2([9, 7, 6, 2, 1]), false);
    expect(isSafe2([1, 3, 2, 4, 5]), true);
    expect(isSafe2([8, 6, 4, 4, 1]), true);
  });

  test('count safe reports', () {
    var reports = [
      [7, 6, 4, 2, 1],
      [1, 2, 7, 8, 9],
      [9, 7, 6, 2, 1],
      [1, 3, 2, 4, 5],
      [8, 6, 4, 4, 1],
      [1, 3, 6, 7, 9]
    ];

    expect(safeCount(Stream.fromIterable(reports), isSafe).then((v) => expect(v, 2)),
        completes);
  });

  test('parse single report', () {
    expect(parseReport('7 6 4 2 1'), [7, 6, 4, 2, 1]);
    expect(parseReport('1 2 7 8 9'), [1, 2, 7, 8, 9]);
    expect(parseReport('9 7 6 2 1'), [9, 7, 6, 2, 1]);
    expect(parseReport('1 3 2 4 5'), [1, 3, 2, 4, 5]);
    expect(parseReport('8 6 4 4 1'), [8, 6, 4, 4, 1]);
    expect(parseReport('1 3 6 7 9'), [1, 3, 6, 7, 9]);
  });

  test('parse report stream', () {
    var reports = Stream.fromIterable([
      '7 6 4 2 1',
      '1 2 7 8 9',
      '9 7 6 2 1',
      '1 3 2 4 5',
      '8 6 4 4 1',
      '1 3 6 7 9'
    ]);

    var expected = [
      [7, 6, 4, 2, 1],
      [1, 2, 7, 8, 9],
      [9, 7, 6, 2, 1],
      [1, 3, 2, 4, 5],
      [8, 6, 4, 4, 1],
      [1, 3, 6, 7, 9]
    ];
    expect(parseReports(reports).toList().then((v) => expect(v, expected)),
        completes);
  });

  test('reads lines from file', (){
    var filePath = p.join(Directory.current.path, 'data', 'day2_sample.txt');
    var lines = [
      '7 6 4 2 1',
      '1 2 7 8 9',
      '9 7 6 2 1',
      '1 3 2 4 5',
      '8 6 4 4 1',
      '1 3 6 7 9'
    ];

    expect(readLines(filePath).toList().then((v) => expect(v, lines)), completes);
  });

  test('counts safe reports from file', (){
    var filePath = p.join(Directory.current.path, 'data', 'day2_sample.txt');
    expect(safeCountFromFile(filePath, isSafe).then((v) => expect(v, 2)), completes);
  });

  test('counts safe reports with dampening from file', (){
    var filePath = p.join(Directory.current.path, 'data', 'day2_sample.txt');
    expect(safeCountFromFile(filePath, isSafe2).then((v) => expect(v, 4)), completes);
  });
}
