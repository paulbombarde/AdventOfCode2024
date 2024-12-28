import 'dart:io';

(int, String) calculate(String filePath) {
  var inputs = File(filePath).readAsLinesSync();
  return calculateFromLines(inputs);
}

(int, String) calculateFromLines(List<String> inputs) {
  var n = Network.fromLines(inputs);
  var tts = n.threes();
  var ts = filterTs(tts);
  var lans = n.LANs();
  return (ts.length, longest(lans));
}

String longest(Iterable<String> lans){
  String ll = "";
  for(var l in lans){
    if(ll.length < l.length) ll = l;
  }
  return ll;
}

typedef ThreeNode = (String, String, String);
int comp(ThreeNode a, ThreeNode b) {
  int c1 = a.$1.compareTo(b.$1);
  if (0 != c1) return c1;
  int c2 = a.$2.compareTo(b.$2);
  if (0 != c2) return c2;
  return a.$3.compareTo(b.$3);
}

class Network {
  final Map<String, Set<String>> connections;

  Network(this.connections);
  Network.fromLines(List<String> lines) : this(splitLines(lines));

  static Map<String, Set<String>> splitLines(List<String> lines) {
    var res = <String, Set<String>>{};
    for (var line in lines) {
      var p = line.split('-');
      if (!res.containsKey(p[0])) res[p[0]] = <String>{};
      if (!res.containsKey(p[1])) res[p[1]] = <String>{};
      res[p[0]]!.add(p[1]);
      res[p[1]]!.add(p[0]);
    }
    print("number nodes ${res.keys.length}");
    return res;
  }

  Set<ThreeNode> threes() {
    var res = <ThreeNode>{};
    for (var e1 in connections.entries) {
      var node1 = e1.key;
      for (var node2 in e1.value) {
        for (var node3 in connections[node2]!) {
          if (connections[node3]!.contains(node1)) {
            var sorted = [node1, node2, node3];
            sorted.sort();
            res.add((sorted[0], sorted[1], sorted[2]));
          }
        }
      }
    }
    return res;
  }

  Set<String> LANs(){
    var res = <String>{};
    for (var e1 in connections.entries) {
        var current = <String>{e1.key};
        for(var n in e1.value){
          var inCurrent = true;
          for(var m in current){
            if(!connections[m]!.contains(n)){
              inCurrent = false;
              break;
            }
          }

          if(inCurrent){
            current.add(n);
          }
        }
        if(0 < current.length){
          var l = List<String>.from(current)..sort();
          res.add(l.join(','));
        }
      }
    return res;
  }
}

Set<ThreeNode> filterTs(Set<ThreeNode> threes) {
  var tts = <ThreeNode>{};
  for (var ts in threes) {
    if (ts.$1[0] == 't' || ts.$2[0] == "t" || ts.$3[0] == 't') tts.add(ts);
  }
  return tts;
}
