import 'package:day17/day17.dart' as day17;

void main(List<String> arguments) {
  var input = [
    "Register A: 66171486",
    "Register B: 0",
    "Register C: 0",
    "",
    "Program: 2,4,1,6,7,5,4,6,1,4,5,5,0,3,3,0"
  ];

  var c = day17.Program.fromLines(input);
  print(c.output());
}
