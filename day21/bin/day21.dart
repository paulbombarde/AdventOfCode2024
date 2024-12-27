import 'package:day21/day21.dart' as day21;

void main(List<String> arguments) {
  var inputs = ["836A", "540A", "965A", "480A", "789A"];
  print('2 robots: ${day21.calculate(inputs)}!');
  print('25 robots: ${day21.calculate2(inputs, 25)}!');
}
