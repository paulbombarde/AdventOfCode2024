import 'package:day7/day7.dart';
import 'package:test/test.dart';

void main() {
  group('Equation', () {
    test('read line', () {
      var line = "161011: 16 10 13";
      expect(Equation.fromLine(line), Equation(161011, [16, 10, 13]));
    });

    test('is valid', () {
      expect(Equation(11, [11]).isValid(), true);
      expect(Equation(11, [12]).isValid(), false);
      expect(Equation(190, [10, 19]).isValid(), true);
      expect(Equation(29, [10, 19]).isValid(), true);
      expect(Equation(29, [11, 19]).isValid(), false);

      expect(Equation(3267, [81, 40, 27]).isValid(), true);
      expect(Equation(83, [17, 5]).isValid(), false);
      expect(Equation(156, [15, 6]).isValid(), false);
      expect(Equation(7290, [6, 8, 6, 15]).isValid(), false);
      expect(Equation(161011, [16, 10, 13]).isValid(), false);
      expect(Equation(192, [17, 8, 14]).isValid(), false);
      expect(Equation(21037, [9, 7, 18, 13]).isValid(), false);
      expect(Equation(292, [11, 6, 16, 20]).isValid(), true);
    });

    test('is valid 2', () {
      expect(Equation(11, [11]).isValid2(), true);
      expect(Equation(11, [12]).isValid2(), false);
      expect(Equation(190, [10, 19]).isValid2(), true);
      expect(Equation(29, [10, 19]).isValid2(), true);
      expect(Equation(29, [11, 19]).isValid2(), false);

      expect(Equation(3267, [81, 40, 27]).isValid2(), true);
      expect(Equation(83, [17, 5]).isValid2(), false);
      expect(Equation(156, [15, 6]).isValid2(), true);
      expect(Equation(7290, [6, 8, 6, 15]).isValid2(), true);
      expect(Equation(161011, [16, 10, 13]).isValid2(), false);
      expect(Equation(192, [17, 8, 14]).isValid2(), true);
      expect(Equation(21037, [9, 7, 18, 13]).isValid2(), false);
      expect(Equation(292, [11, 6, 16, 20]).isValid2(), true);
    });

    test('combine ints', (){
      expect(Equation.combine(1, 2), 12);
      expect(Equation.combine(11, 22), 1122);
      expect(Equation.combine(1, 2345), 12345);
      expect(Equation.combine(12, 345), 12345);
      expect(Equation.combine(123, 45), 12345);
      expect(Equation.combine(1234, 5), 12345);
      expect(Equation.combine(12340, 5), 123405);
      expect(Equation.combine(1234, 50), 123450);
      expect(Equation.combine(1234, 10), 123410);
    });
  });



  group('ValidSum', () {
    test('add valid lines', () {
      var lines = [
        '190: 10 19',
        '3267: 81 40 27',
        '83: 17 5',
        '156: 15 6',
        '7290: 6 8 6 15',
        '161011: 16 10 13',
        '192: 17 8 14',
        '21037: 9 7 18 13',
        '292: 11 6 16 20'
      ];
      
      expect(ValidSum.addLines(lines), (3749, 11387));
    });
  });
}
