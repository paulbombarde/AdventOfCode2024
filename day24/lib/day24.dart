import 'dart:io';

int calculate(String filePath) {
  var input = File(filePath).readAsLinesSync();
  return calculateFromLines(input);
}

int calculateFromLines(List<String> lines) {
  var c=Computer.fromLines(lines);
  var v=c.compute();
  return value(v);
}

abstract class Node {
  bool? val;
  bool value(Map<String, Node> nodes);
}

class Val extends Node {
  Val(v) {
    super.val = v;
  }
  @override
  bool value(Map<String, Node> nodes) {
    return val!;
  }
}

abstract class Op extends Node {
  String x1;
  String x2;
  Op(this.x1, this.x2);

  @override
  bool value(Map<String, Node> nodes) {
    if (val == null) {
      var v1 = nodes[x1]!.value(nodes);
      var v2 = nodes[x2]!.value(nodes);
      val = run(v1, v2);
    }
    return val!;
  }

  bool run(bool x1, bool x2);
}

class And extends Op {
  And(super.x1, super.x2);
  @override
  bool run(bool x1, bool x2) {
    return x1 && x2;
  }
}

class Or extends Op {
  Or(super.x1, super.x2);
  @override
  bool run(bool x1, bool x2) {
    return x1 || x2;
  }
}

class Xor extends Op {
  Xor(super.x1, super.x2);
  @override
  bool run(bool x1, bool x2) {
    return x1 ^ x2;
  }
}

class Computer {
  var nodes = <String, Node>{};

  Computer(this.nodes);
  Computer.fromLines(List<String> lines) {
    int i = 0;

    for (; 0 < lines[i].length; ++i) {
      var elems = lines[i].split(': ');
      nodes[elems[0]] = Val(elems[1] == '1');
    }
    ++i;

    for (; i < lines.length; ++i) {
      var elems = lines[i].split(' ');
      nodes[elems[4]] = node(elems[1], elems[0], elems[2]);
    }
  }

  Node node(String op, String x1, String x2) {
    switch (op) {
      case "AND":
        return And(x1, x2);
      case "OR":
        return Or(x1, x2);
      case "XOR":
        return Xor(x1, x2);
      default:
        throw "Unexpected";
    }
  }

  Map<String, bool> compute() {
    return {for (var e in nodes.entries) e.key: e.value.value(nodes)};
  }
}

int value(Map<String, bool> values){
  var zs = values.keys.where((v) => v[0]=='z').toList()..sort();
  var res = 0;
  for(var z in zs.reversed){
    int val = (values[z]!)?1:0;
    res = (res << 1) + val;
  }
  return res;
}
