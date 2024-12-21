import 'package:day17/day17.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    var sample = [
      "Register A: 729",
      "Register B: 0",
      "Register C: 0",
      "",
      "Program: 0,1,5,4,3,0"
    ];

    var c = Program.fromLines(sample);
    expect(c.output(), "4,6,3,5,6,3,5,2,1,0");
  });

  test('adv, opcode 0', (){
    var s = Computer(2024, 2, 1);
    s.adv(0);
    expect(s.A, 2024);
    s.adv(1);
    expect(s.A, 1012);
    s.adv(2);
    expect(s.A, 253);
    s.adv(3);
    expect(s.A, 31);
    s.adv(5); // B == 2
    expect(s.A, 7);
    s.adv(6); // C == 1
    expect(s.A, 3);

    s.A = 2024;
    s.adv(4); // always 0
    expect(s.A, 0);
  });

  test('bxl, opcode 1', (){
    var s = Computer(0, 29, 0);
    s.bxl(7);
    expect(s.B, 26);
  });

  test('bst, opcode 2', (){
    var s = Computer(0, 0, 9);
    s.bst(6);
    expect(s.A, 0);
    expect(s.B, 1);
    expect(s.C, 9);
    expect(s.p, 2);
  });

  test('jnz, opcode 3', (){
    var s = Computer(2024, 0, 0);
    s.exec(0, 1); // adv, opcode 0
    expect(s.A, 1012);
    s.exec(5, 4); // out, opcode 5
    expect(s.output, [4]);
    s.exec(3, 0); // jnz, opcode 3
    expect(s.p, 0);
    s.exec(0, 1);
    expect(s.p, 2);

    s.A=0;
    s.exec(3, 0); // jnz, opcode 3
    expect(s.p, 4);
  });

  test('bxc, opcode 4', (){
    var s = Computer(0, 2024, 43690);
    s.bxc(0);
    expect(s.B, 44354);
    expect(s.C, 43690);
  });

  test('out, opcode 5', (){
    var s = Computer(10, 0, 0);
    s.out(0);
    s.out(1);
    s.out(4);
    expect(s.output, [0,1,2]);
  });

  test('bdv, opcode 6',(){
    var s = Computer(2024, 2, 1);
    s.bdv(1);
    expect(s.A, 2024);
    expect(s.B, 1012);
    expect(s.C, 1);
  });

  test('cdv, opcode 7',(){
    var s = Computer(2024, 2, 1);
    s.cdv(1);
    expect(s.A, 2024);
    expect(s.B, 2);
    expect(s.C, 1012);
  });

  test('sample auto', (){
    var s = Computer(2024, 0, 0);
    s.run([0,1,5,4,3,0]);
    expect(s.A, 0);
    expect(s.output, [4,2,5,6,7,7,7,7,3,1,0]);
  });

  test('sample2', (){
    var s = Computer(729, 0, 0);
    s.run([0,1,5,4,3,0]);
    expect(s.A, 0);
    expect(s.output, [4,6,3,5,6,3,5,2,1,0]);
  });

  test('repeat', (){
    var s = Program(729, 0, 0, [0,3,5,4,3,0]);
    expect(s.repeatABruteForce(), 117440);
    print(s.assembly());
    expect(s.repeatA(3), 117440);
  });
}
