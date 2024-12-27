import 'dart:io';
import 'dart:math';

(int, int) calculate(String filePath) {
  var inputs = File(filePath).readAsLinesSync();
  return calculateFromStrings(inputs);
}

(int, int) calculateFromStrings(Iterable<String> inputs) {
  var intInputs = inputs.map(int.parse);
  var secrets2000 = intInputs.map((s) => nextIter(s, 2000));
  var best = bestSequence(intInputs, 2000);
  return (secrets2000.fold(0, (a, b) => a + b), best.$2);
}

((int, int, int, int), int) bestSequence(Iterable<int> secrets, int req) {
  var ds = DeltasMap();
  for (var s in secrets) {
    var bs = bananas(s, req);
    for (var e in deltas(bs).entries) {
      ds[e.key] = (ds[e.key] ?? 0) + e.value;
    }
  }

  var m = ds.values.reduce(max);
  for (var d in ds.entries) {
    if (d.value == m) return (d.key, d.value);
  }
  return ((0, 0, 0, 0), 0);
}

int nextIter(int secret, int req) {
  int s = secret;
  for (int i = 0; i < req; ++i) s = next(s);
  return s;
}

int next(int secret) {
  int n = prune(mix(secret, secret * 64));
  n = prune(mix(n, n ~/ 32));
  n = prune(mix(n, n * 2048));
  return n;
}

List<int> bananas(int secret, int req) {
  int prev = secret;
  var res = <int>[];
  for (int i = 0; i < req; ++i) {
    res.add(prev % 10);
    prev = next(prev);
  }
  return res;
}

typedef DeltasMap = Map<(int, int, int, int), int>;
DeltasMap deltas(List<int> bananas) {
  var d = DeltasMap();
  for (int i = 4; i < bananas.length; ++i) {
    var key = (
      delta(bananas, i - 3),
      delta(bananas, i - 2),
      delta(bananas, i - 1),
      delta(bananas, i)
    );
    if (d.containsKey(key)) continue;
    d[key] = bananas[i];
  }
  return d;
}

int delta(List<int> bananas, int i) {
  return bananas[i] - bananas[i - 1];
}

int mix(int secret, int val) {
  return secret ^ val;
}

int prune(int secret) {
  return secret % 16777216;
}
