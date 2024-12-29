import 'package:day24/day24.dart';
import 'package:test/test.dart';

void main() {
  var small = [
    "x00: 1",
    "x01: 1",
    "x02: 1",
    "y00: 0",
    "y01: 1",
    "y02: 0",
    "",
    "x00 AND y00 -> z00",
    "x01 XOR y01 -> z01",
    "x02 OR y02 -> z02"
  ];

  var big = [
    "x00: 1",
    "x01: 0",
    "x02: 1",
    "x03: 1",
    "x04: 0",
    "y00: 1",
    "y01: 1",
    "y02: 1",
    "y03: 1",
    "y04: 1",
    "",
    "ntg XOR fgs -> mjb",
    "y02 OR x01 -> tnw ",
    "kwq OR kpj -> z05 ",
    "x00 OR x03 -> fst ",
    "tgd XOR rvg -> z01",
    "vdt OR tnw -> bfw ",
    "bfw AND frj -> z10",
    "ffh OR nrd -> bqk ",
    "y00 AND y03 -> djm",
    "y03 OR y00 -> psh ",
    "bqk OR frj -> z08 ",
    "tnw OR fst -> frj ",
    "gnj AND tgd -> z11",
    "bfw XOR mjb -> z00",
    "x03 OR x00 -> vdt ",
    "gnj AND wpb -> z02",
    "x04 AND y00 -> kjc",
    "djm OR pbm -> qhw ",
    "nrd AND vdt -> hwm",
    "kjc AND fst -> rvg",
    "y04 OR y02 -> fgs ",
    "y01 AND x02 -> pbm",
    "ntg OR kjc -> kwq ",
    "psh XOR fgs -> tgd",
    "qhw XOR tgd -> z09",
    "pbm OR djm -> kpj ",
    "x03 XOR y03 -> ffh",
    "x00 XOR y04 -> ntg",
    "bfw OR bqk -> z06 ",
    "nrd XOR fgs -> wpb",
    "frj XOR qhw -> z04",
    "bqk OR frj -> z07 ",
    "y03 OR x01 -> nrd ",
    "hwm AND bqk -> z03",
    "tgd XOR rvg -> z12",
    "tnw OR pbm -> gnj "
  ];

  test('calculate', () {
    expect(calculateFromLines(small), 4);
    expect(calculateFromLines(big), 2024);
  });

  test('small', () {
    var c = Computer.fromLines(small);
    var values = {
      "x00": true,
      "x01": true,
      "x02": true,
      "y00": false,
      "y01": true,
      "y02": false,
      "z00": false,
      "z01": false,
      "z02": true,
    };
    expect(c.compute(), values);
    expect(value(values), 4);
  });

  test('big', () {
    var c = Computer.fromLines(big);
    var values = {
      "bfw": true,
      "bqk": true,
      "djm": true,
      "ffh": false,
      "fgs": true,
      "frj": true,
      "fst": true,
      "gnj": true,
      "hwm": true,
      "kjc": false,
      "kpj": true,
      "kwq": false,
      "mjb": true,
      "nrd": true,
      "ntg": false,
      "pbm": true,
      "psh": true,
      "qhw": true,
      "rvg": false,
      "tgd": false,
      "tnw": true,
      "vdt": true,
      "wpb": false,
      "x00": true,
      "x01": false,
      "x02": true,
      "x03": true,
      "x04": false,
      "y00": true,
      "y01": true,
      "y02": true,
      "y03": true,
      "y04": true,
      "z00": false,
      "z01": false,
      "z02": false,
      "z03": true,
      "z04": false,
      "z05": true,
      "z06": true,
      "z07": true,
      "z08": true,
      "z09": true,
      "z10": true,
      "z11": false,
      "z12": false,
    };
    expect(c.compute(), values);
    expect(value(values), 2024);
  });

  test('And', () {
    expect(And("A", "B").run(false, false), false);
    expect(And("A", "B").run(true, false), false);
    expect(And("A", "B").run(false, true), false);
    expect(And("A", "B").run(true, true), true);
  });

  test('Or', () {
    expect(Or("A", "B").run(false, false), false);
    expect(Or("A", "B").run(true, false), true);
    expect(Or("A", "B").run(false, true), true);
    expect(Or("A", "B").run(true, true), true);
  });

  test('Xor', () {
    expect(Xor("A", "B").run(false, false), false);
    expect(Xor("A", "B").run(true, false), true);
    expect(Xor("A", "B").run(false, true), true);
    expect(Xor("A", "B").run(true, true), false);
  });
}
