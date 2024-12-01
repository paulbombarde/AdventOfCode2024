import 'dart:io';
import 'dart:convert';

Future<int> totalDistFromFile(String filePath) async {
  return readListsFromFile(filePath)
    .then((v) => totalDist(v.$1, v.$2));
}

int totalDist(List<int> list1, List<int> list2){
  list1.sort();
  list2.sort();
  return sum(distsFromSorted(list1, list2));
}

List<int> distsFromSorted(List<int> sortedList1, List<int> sortedList2) {
  return [
    for(int i = 0; i<sortedList1.length; i+= 1)
      (sortedList1[i] - sortedList2[i]).abs()
  ];
}

int sum(Iterable<int> list) {
  return list.fold(0, (p,e) => p + e);
}

Future<(List<int>, List<int>)> readListsFromFile(String filePath) async {
  var lines = readLines(filePath);
  var pairs = pairsFromLines(lines);
  return listsFromPairs(pairs);
}

Stream<String> readLines(String filePath) {
  final file = File(filePath);
  return file.openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter());
}

Stream<(int, int)> pairsFromLines(Stream<String> lines) {
  return lines.map(pairFromLine);
}

Future<(List<int>, List<int>)> listsFromPairs(Stream<(int, int)> s) async {
  List<int> lA = [], lB = [];
  await for(var (a,b) in s) {
        lA.add(a);
        lB.add(b);
  }
  return (lA, lB);
}

(int, int) pairFromLine(String l)
{
  int e1=0;

  for(;e1<l.length; ++e1) {
    if(l[e1] == ' ') {
      break;
    }
  }

  int s2=e1+1;
  for(;s2<l.length; ++s2) {
    if(l[s2] != ' ') {
      break;
    }
  }

  return (int.parse(l.substring(0, e1)), int.parse(l.substring(s2)));
}

Future<int> similarityScoreFromFile(String filePath) {
  return readListsFromFile(filePath).then( (v) => similarityScoreFromLists(v.$1, v.$2));
}

int similarityScoreFromLists(List<int> l1, List<int> l2) {
  var counts = countsFromList(l2);
  int score = 0;
  for(int k in l1) {
    if(counts.containsKey(k)){
      score += k * counts[k]!;
    }
  }
  return score;
}

Map<int, int> countsFromList(Iterable<int> l)
{
  var m = <int, int>{};
  for(var v in l) {
    m[v] = (m[v] ?? 0) + 1;
  }
  return m;
}