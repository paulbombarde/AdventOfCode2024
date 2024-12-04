import 'package:day4/day4.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

void main() {
  var filePath = p.join(Directory.current.path, 'data', 'day4_sample.txt');

  test('counts xmas small', () {
    var input = [
      "..X...", //
      ".SAMX.",
      ".A..A.",
      "XMAS.S",
      ".X...."
    ];

    expect(xmasCountDir(input, 0, 2, 1, 0), 0);
    expect(xmasCountDir(input, 0, 2, 1, 1), 1);
    expect(xmasCountDir(input, 1, 4, 0, -1), 1);
    expect(xmasCountDir(input, 1, 4, 0, 1), 0);
    expect(xmasCountDir(input, 3, 0, 0, 1), 1);
    expect(xmasCountDir(input, 4, 1, -1, 0), 1);

    expect(xmasCount(input), 4);
  });

  test('counts xmas medium', () {
    var input = [
      "MMMSXXMASM",
      "MSAMXMSMSA",
      "AMXSXMAAMM",
      "MSAMASMSMX",
      "XMASAMXAMM",
      "XXAMMXXAMA",
      "SMSMSASXSS",
      "SAXAMASAAA",
      "MAMMMXMMMM",
      "MXMXAXMASX"
    ];

    expect(xmasCountDir(input, 4, 6, -1, 0), 1);
    expect(xmasCountDir(input, 4, 6, 0, -1), 1);
    expect(xmasCountDir(input, 4, 6, 1, 0), 0);
    expect(xmasCountDir(input, 4, 6, 0, 1), 0);

    expect(xmasCountAt(input, 4, 6), 2);

    expect(xmasCount(input), 18);
  });

  test('read lines', (){
    var input = [
      "MMMSXXMASM",
      "MSAMXMSMSA",
      "AMXSXMAAMM",
      "MSAMASMSMX",
      "XMASAMXAMM",
      "XXAMMXXAMA",
      "SMSMSASXSS",
      "SAXAMASAAA",
      "MAMMMXMMMM",
      "MXMXAXMASX"
    ];
    expect(readLines(filePath), input);
  });

  test('xmas count from file', (){
    expect(xmasCountFromFile(filePath), 18);
  });

  test('x-mas count', (){
    var input = [
      "MMMSXXMASM",
      "MSAMXMSMSA",
      "AMXSXMAAMM",
      "MSAMASMSMX",
      "XMASAMXAMM",
      "XXAMMXXAMA",
      "SMSMSASXSS",
      "SAXAMASAAA",
      "MAMMMXMMMM",
      "MXMXAXMASX"
    ];

    expect(isXMas(input, 1, 2), 1);
    expect(isXMas(input, 0, 2), 0);

    expect(countXMas(input), 9);
  });
}
