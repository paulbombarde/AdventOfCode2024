import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class Computer {
  int A = 0;
  int B = 0;
  int C = 0;
  int p = 0;
  List<int> output = <int>[];

  Computer(this.A, this.B, this.C);

  void run(List<int> instructions) {
    while (p < instructions.length) {
      exec(instructions[p], instructions[p + 1]);
    }
  }

  void exec(int opcode, int op) {
    switch (opcode) {
      case 0:
        adv(op);
        break;
      case 1:
        bxl(op);
        break;
      case 2:
        bst(op);
        break;
      case 3:
        jnz(op);
        break;
      case 4:
        bxc(op);
        break;
      case 5:
        out(op);
        break;
      case 6:
        bdv(op);
        break;
      case 7:
        cdv(op);
        break;
    }
  }

  void adv(int op) {
    A = A >> combo(op);
    p += 2;
  }

  void bxl(int op) {
    B = B ^ op;
    p += 2;
  }

  void bst(int op) {
    B = combo(op) % 8;
    p += 2;
  }

  void jnz(int op) {
    if (0 == A) {
      p += 2;
    } else {
      p = op;
    }
  }

  void bxc(int op) {
    B = B ^ C;
    p += 2;
  }

  void out(int op) {
    output.add(combo(op) % 8);
    p += 2;
  }

  void bdv(int op) {
    B = A >> combo(op);
    p += 2;
  }

  void cdv(int op) {
    C = A >> combo(op);
    p += 2;
  }

  int combo(int op) {
    if (op == 4) return A;
    if (op == 5) return B;
    if (op == 6) return C;
    return op;
  }
}

class Program {
  int A = 0;
  int B = 0;
  int C = 0;
  final List<int> instructions;

  Program(this.A, this.B, this.C, this.instructions);

  factory Program.fromLines(List<String> lines) {
    return Program(
        int.parse(lines[0].split(' ')[2]),
        int.parse(lines[1].split(' ')[2]),
        int.parse(lines[2].split(' ')[2]),
        [for (var v in lines[4].split(' ')[1].split(',')) int.parse(v)]);
  }

  String output() {
    var c = Computer(A, B, C);
    c.run(instructions);
    return c.output.map((x) => x.toString()).join(',');
  }

  // Brute force, obviously not suitable.
  int repeatABruteForce() {
    Function eq = const ListEquality().equals;
    for (int i = 0;; ++i) {
      var c = Computer(i, B, C);
      c.run(instructions);
      if (eq(c.output, instructions)) return i;
    }
  }

  String assembly() {
    var res = <String>[];
    var f = NumberFormat("00");
    for (int i = 0; i < instructions.length; i += 2) {
      res.add("[${f.format(i)}] " + instructionAssembly(i));
    }
    return res.join('\n');
  }

  String instructionAssembly(int i) {
    return opcodeAssembly(instructions[i], instructions[i + 1]);
  }

  String opcodeAssembly(int opcode, int op) {
    switch (opcode) {
      case 0:
        return "adv $op - A=A>>${comboAssembly(op)}";
      case 1:
        return "bxl $op - B=B^$op";
      case 2:
        return "bst $op - B=${comboAssembly(op)}%8";
      case 3:
        return "jnz $op - goto ${op}";
      case 4:
        return "bxc $op - B=B^C";
      case 5:
        return "out $op - out(${comboAssembly(op)}%8)";
      case 6:
        return "bdv $op - B=A>>${comboAssembly(op)}";
      case 7:
        return "bdv $op - C=A>>${comboAssembly(op)}";
    }
    throw "WTF???";
  }

  String comboAssembly(int op) {
    if (op == 4) return "A";
    if (op == 5) return "B";
    if (op == 6) return "C";
    return op.toString();
  }

  int repeatA(int bitsPerIter) {
    var block = instructions.getRange(0, instructions.length - 2).toList();
    var contenders = <int>[0];
    for (int i = 0; i < instructions.length; ++i) {
      var next = <int>[];
      var target = instructions[instructions.length - 1 - i];
      //print('$i - $target');
      //print(">> $contenders");

      for (var c in contenders) {
        c = c << bitsPerIter;
        for (int j = 0; j < (1 << bitsPerIter); ++j) {
          var computer = Computer(c + j, 0, 0);
          computer.run(block);

          if (target == computer.output[0]) {
            next.add(c + j);
          }
        }
      }

      contenders = next;
    }
    //print(">> $contenders");
    return contenders.reduce(min);
  }
}
