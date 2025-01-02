import 'dart:io';

int calculate(String filePath) {
  var input = File(filePath).readAsLinesSync();
  return calculateFromLines(input);
}

int calculateFromLines(List<String> lines) {
  var c = Computer.fromLines(lines);
  var v = c.compute();

  var f = Fixer.fromLines(lines);
  f.fixit();

  return value(v);
}

abstract class Node {
  bool? val;
  bool value(Map<String, Node> nodes);
  void reset() {
    val = null;
  }
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

  void reset() {
    for (var v in nodes.values) {
      v.reset();
    }
  }
}

int value(Map<String, bool> values) {
  var zs = values.keys.where((v) => v[0] == 'z').toList()..sort();
  var res = 0;
  for (var z in zs.reversed) {
    int val = (values[z]!) ? 1 : 0;
    res = (res << 1) + val;
  }
  return res;
}

typedef Entry = (String, String, String, String);

class Fixer {
  var ops = <Entry>[];
  var rawOps = <Entry>[];
  var fixes = <String, String>{};
  var temps = <String, String>{};

  Fixer(this.ops);
  Fixer.fromLines(List<String> lines) {
    int i = 0;
    for (; 0 < lines[i].length; ++i);
    ++i;

    for (; i < lines.length; ++i) {
      var elems = lines[i].split(' ');
      // content (x, OP, y, r).
      // We ensure that operands are ordered with smaller first so
      // we don't have to match both of them to identify them later.
      if (elems[0].compareTo(elems[2]) < 0)
        ops.add((elems[0], elems[1], elems[2], elems[4]));
      else
        ops.add((elems[2], elems[1], elems[0], elems[4]));
      rawOps.add((elems[0], elems[1], elems[2], elems[4]));
    }
  }

  void fixit() {
    var zs = ops.where((op) => (null != zRegEx.firstMatch(op.$4))).toList();
    zs.sort((a, b) => a.$4.compareTo(b.$4));
    var nz = zs.length;
    print("Z size: $nz");

    // binary sum: start with low bits, get a carry bit, then
    // xnn,ynn,cnn => snn,tnn => unn => znn,cnn+1
    // (0,0,0) => (0,0) => 0 => (0,0)
    // (1,0,0) => (1,0) => 0 => (1,0)
    // (0,1,0) => (1,0) => 0 => (1,0)
    // (1,1,0) => (0,1) => 0 => (0,1)
    // (0,0,1) => (0,0) => 0 => (1,0)
    // (1,0,1) => (1,0) => 1 => (0,1)
    // (0,1,1) => (1,0) => 1 => (0,1)
    // (1,1,1) => (0,1) => 1 => (1,1)

    // For z00:
    // x00 XOR y00 => z00
    // x00 AND y00 => c01
    //
    // x XOR y => s    // Op1 XOR between xNN and yNN
    // x AND y => t    // Op2 AND between xNN and yNN
    // s XOR c => z    // Op3 XOR resulting in zNN
    // s AND c => u    // Op4
    // u OR  t => c+1  // Op5

    // The last cnn+1 is the high bit of z
    var xyXORs = <int, Entry>{};
    var xyANDs = <int, Entry>{};
    var genZs = <int, Entry>{};
    var otherXORs = <Entry>{};
    var otherANDs = <Entry>{};
    var ORs = <Entry>{};
    for (var op in ops) {
      if (op.$2 == "XOR") {
        var idx = readXYIndex(op);
        if (idx != null) {
          xyXORs[idx] = op;
          continue;
        }
      }

      if (op.$2 == "AND") {
        var idx = readXYIndex(op);
        if (idx != null) {
          xyANDs[idx] = op;
        } else {
          otherANDs.add(op);
        }
        continue;
      }

      if (op.$2 == "OR") {
        ORs.add(op);
      }

      var idx = readZIndex(op);
      if (idx != null) {
        genZs[idx] = op;
        continue;
      }

      if (op.$2 == "XOR") {
        otherXORs.add(op);
      }
    }

    // Coherency check
    if (xyXORs.length != zs.length - 1) {
      // last z is the result of the previous round.
      throw "Wrong number of op1s ${xyXORs.length}/${zs.length}";
    }
    if (xyANDs.length != zs.length - 1) {
      // no carry for first step.
      throw "Wrong number of op2s ${xyANDs.length}/${zs.length}";
    }

    // the last zNN should match a OR
    if (genZs[zs.length - 1]!.$2 != "OR") {
      throw "Last Z op is not a OR: ${genZs[zs.length - 1]}";
    }
    // the 00 xyXOR should be z00
    if (xyXORs[0]!.$4 != "z00") {
      throw "x00 XOR y00 doesn't produce z00: ${xyXORs[0]}";
    }

    // All other zNN ops should be XOR
    print("\nAnalyzing operations producing z regitries:");
    for (int i = 1; i < zs.length - 1; ++i) {
      if (!genZs.containsKey(i)) {
        print("Missing z$i");
        continue;
      }
      if (genZs[i]!.$2 != "XOR") {
        print("Weird z$i: ${genZs[i]}");
      }
    }

    // The previous print shows the following anomaliy
    // (dkk, OR, pbd, z15) => That's a 'C'

    // It also shows that no production for z23 and z39
    // Let's print the matching ones from the "zs"
    print("z23: ${zs[23]}");
    print("z39: ${zs[39]}");
    // (x23, AND, y23, z23) => That's a 'T'
    // (bdr, AND, fsp, z39) => That's a 'U'

    print("\nAnalyzing XOR operations that do not produce a z nor consume x/y");
    for (var o in otherXORs) {
      print(o);
    }
    // The previous XORs that do not produce a z but are not xy give us 3 more anomalies
    // Those should produce some 'zNN' and must then be swapped with one of the 3 preceeding ops.
    // (cpv, XOR, fwr, kqk)
    // (hpw, XOR, kph, cgq)
    // (bdr, XOR, fsp, fnr)

    // Let's print the ops that would use those registries
    for (var o in rawOps) {
      for (var r in ["fnr", "kqk", "cgq"])
        if (o.$1 == r || o.$3 == r) print("** $o");
    }
    // The previous print:
    // ** (rbr, AND, kqk, bbm)
    // ** (kqk, XOR, rbr, z16)
    // ** (qdg, OR, cgq, ngq)
    // ** (fnr, OR, nrj, sbn)
    // So 'kqk' is either a "C" or a "S"
    // and 'cgq' and 'fnr' are either "T" or "U"

    // So by elimination the registries for the 2 following ops should be swapped:
    // (dkk, OR, pbd, z15)
    // (cpv, XOR, fwr, kqk)

    // We are left with matching those 4, that may be find by checking which one produce a correct z23/z39
    // But in fact, we don't care.
    // (hpw, XOR, kph, cgq)
    // (bdr, XOR, fsp, fnr)
    // (x23, AND, y23, z23) => That's a 'T'
    // (bdr, AND, fsp, z39) => That's a 'U'

    // Let's check that the outputs of ORs ('C') are indeed inputs for both a AND and a XOR
    print("\nChecking OR operation whose registry is not reused in XOR or AND");
    var cs = ORs.map((e) => e.$4).toSet();
    for (var c in cs) {
      bool gotAND = false;
      bool gotXOR = false;
      for (var o in ops) {
        if (o.$1 != c && o.$3 != c) continue;
        if (o.$2 == "XOR") gotXOR = true;
        if (o.$2 == "AND") gotAND = true;
      }
      if (!gotXOR || !gotAND) print(c);
    }
    // Deadend: all seem to match, except z15 and z45 which are expected.

    print(
        "\nChecking x/y XOR results that are not matched with the result of a OR");
    var ess = xyXORs.values.map((e) => e.$4).toSet();
    for (var s in ess) {
      for (var o in ops) {
        if (o.$1 == s) {
          if (!cs.contains(o.$3)) print("Strange S: $s / $o");
          continue;
        }
        if (o.$3 == s) {
          if (!cs.contains(o.$1)) print("Strange S: $s / $o");
          continue;
        }
      }
    }
    // The previous prints:
    // Strange S: dqq / (dqq, XOR, wbd, z01) => either dqq or wbd or z01 are wrong
    // Strange S: dqq / (dqq, AND, wbd, kwk)
    // Strange S: rbr / (kqk, AND, rbr, bbm) => we know that kqk should be swapped with z15 already
    // Strange S: rbr / (kqk, XOR, rbr, z16)
    // Strange S: nbc / (nbc, OR, skn, pdf) => nbc is not a 'S', it should be a T or a U
    for (var o in ops) {
      if ({"dqq", "wbd", "nbc"}.contains(o.$4)) print("** $o");
    }
    // ** (x00, AND, y00, wbd) => T00 // On 00, no C, so no U, so T00 is C01
    // ** (x01, XOR, y01, dqq) => S01 // So dqq XOR wbd ~> S01 XOR C01 => z01 is ok.
    // ** (x05, XOR, y05, nbc) => S05

    print(
        "\nChecking non x/y AND results that are not matched with the result of a x/y AND");
    var ts = xyANDs.values.map((e) => e.$4).toSet();
    var us = otherANDs.map((e) => e.$4).toSet();
    for (var u in us) {
      for (var o in ops) {
        if (o.$1 == u) {
          if (!ts.contains(o.$3)) print("Strange U: $u / $o");
          continue;
        }
        if (o.$3 == u) {
          if (!ts.contains(o.$1)) print("Strange U: $u / $o");
          continue;
        }
      }
    }
    for (var t in ts) {
      for (var o in ops) {
        if (o.$1 == t) {
          if (!us.contains(o.$3)) print("Strange T: $t / $o");
          continue;
        }
        if (o.$3 == t) {
          if (!us.contains(o.$1)) print("Strange T: $t / $o");
          continue;
        }
      }
    }
    // Strange T: wbd / (dqq, XOR, wbd, z01) => known as start anomaly
    // Strange T: wbd / (dqq, AND, wbd, kwk)
    // Strange T: svm / (rgq, XOR, svm, z05) => either svm or rgq should be swapped with nbc as (x05, XOR, y05, nbc)
    // Strange T: svm / (rgq, AND, svm, skn)
    // Strange U: skn / (nbc, OR, skn, pdf)
    // Strange U: qdg / (cgq, OR, qdg, ngq)
    // Strange T: nrj / (fnr, OR, nrj, sbn)
    for(var o in ops){
      if(o.$4 == "rgq" || o.$4 == "svm" || o.$4 == "nbc") print("** $o");
    }
    // ** (x05, AND, y05, svm) => svm matches a "T"
    // ** (brg, OR, ppw, rgq) => rgq matches a "C"

    // Summary around nbc:
    // (nbc, OR, skn, pdf) => nbc is U or T
    // (x05, XOR, y05, nbc) => nbc is S05 (wrong)
    // (rgq, XOR, svm, z05) => S05 is either rgq or svm 
    // (x05, AND, y05, svm) => svm could be T05
    // (brg, OR, ppw, rgq) => rgq could be C05, nbc is cannot be a C
    // => swap svm and nbc
    // nbc ~ T05
    // svm ~ S05

    // Rules reminder:
    // x XOR y => s    // Op1 XOR between xNN and yNN
    // x AND y => t    // Op2 AND between xNN and yNN
    // s XOR c => z    // Op3 XOR resulting in zNN
    // s AND c => u    // Op4
    // u OR  t => c+1  // Op5
    print("");
    var toSwap=["z15", "kqk", "svm", "nbc", "z23", "z39", "cgq", "fnr"]..sort();
    print(toSwap.join(","));
  }

  static var xRegEx = RegExp(r'^x(\d{2})');
  static var yRegEx = RegExp(r'^y(\d{2})');
  static var zRegEx = RegExp(r'^z(\d{2})');
  int? readXYIndex((String, String, String, String) op) {
    var mx = xRegEx.firstMatch(op.$1);
    var my = yRegEx.firstMatch(op.$3);
    if (mx == null || my == null) return null;

    var xi = int.parse(mx.group(1)!);
    var yi = int.parse(my.group(1)!);
    if (xi != yi) return null;

    return xi;
  }

  int? readZIndex((String, String, String, String) op) {
    var mz = zRegEx.firstMatch(op.$4);
    if (mz == null) return null;

    return int.parse(mz.group(1)!);
  }
}
