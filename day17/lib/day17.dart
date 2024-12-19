import 'dart:io';

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

  factory Program.fromFile(String filePath) {
    var lines = File(filePath).readAsLinesSync();
    return Program.fromLines(lines);
  }

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
}
