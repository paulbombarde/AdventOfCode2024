import 'package:day1/day1.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

void main() {
  test('sort a list', () {
    var list = [3, 4, 2, 1, 3, 3];
    var sorted = [1, 2, 3, 3, 3, 4];
    list.sort();
    expect(list, sorted);
  });

  test('compute sorted list dists', () {
    var sorted1 = [1, 2, 3, 3, 3, 4];
    var sorted2 = [3, 3, 3, 4, 5, 9];
    var distsEx = [2, 1, 0, 1, 2, 5];
    expect(distsFromSorted(sorted1, sorted2), distsEx);
    expect(distsFromSorted(sorted2, sorted1), distsEx);
  });

  test('adds numbers from list', () {
    var dists = [2, 1, 0, 1, 2, 5];
    var sumEx = 11;
    expect(sum(dists), sumEx);
  });

  test('compute total dist', () {
    var listA = [3, 4, 2, 1, 3, 3];
    var listB = [4, 3, 5, 3, 9, 3];
    expect(totalDist(listA, listB), 11);
  });

  test('split line', () {
    expect(pairFromLine('1   2\n'), (1, 2));
    expect(pairFromLine('1 2\n'), (1, 2));
    expect(pairFromLine('11      22'), (11, 22));
  });

  test('split lines', () {
    var lines = Stream.fromIterable(['1 2', '3 4', '5 6']);
    var expected = [(1, 2), (3, 4), (5, 6)];
    expect(
        pairsFromLines(lines).toList().then((v) => expect(v, expected)), completes);
  });

  test('read lines', () {
    var filePath = p.join(Directory.current.path, 'data', 'day1_sample.txt');
    var expected = [
      "3   4",
      "4   3",
      "2   5",
      "1   3",
      "3   9",
      "3   3"
    ];
    expect(readLines(filePath).toList().then((v) => expect(v, expected)), completes);
  });

  test('lists from pairs', (){
    var pairs = Stream.fromIterable([(1, 2), (3, 4), (5, 6)]);
    var lists = ([1, 3, 5], [2, 4, 6]);
    expect(listsFromPairs(pairs).then((v){
      expect(v.$1, lists.$1);
      expect(v.$2, lists.$2);
      }), completes);
  });

  test('read list from file', (){
    var filePath = p.join(Directory.current.path, 'data', 'day1_sample.txt');
    var list1 = [3, 4, 2, 1, 3, 3];
    var list2 = [4, 3, 5, 3, 9, 3];
    expect(readListsFromFile(filePath).then((v){
      expect(v.$1, list1);
      expect(v.$2, list2);
    }), completes);
  });

  test('dist from file', (){
    var filePath = p.join(Directory.current.path, 'data', 'day1_sample.txt');
    expect(totalDistFromFile(filePath).then((v){
      expect(v, 11);
    }), completes);
  });

  test('count from list', (){
    var list = [3, 4, 2, 1, 3, 3, 4];
    var expected = {1: 1, 2: 1, 3: 3, 4:2};
    expect(countsFromList(list), expected);
  });

  test('similarity score from lists', (){
    var list1 = [3, 4, 2, 1, 3, 3];
    var list2 = [4, 3, 5, 3, 9, 3];
    expect(similarityScoreFromLists(list1, list2), 31);
  });

  test('similarity score from file', (){
    var filePath = p.join(Directory.current.path, 'data', 'day1_sample.txt');
    expect(similarityScoreFromFile(filePath).then((value) => expect(value,31)), completes);
  });
}
