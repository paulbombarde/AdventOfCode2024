import 'package:day3/day3.dart';

void main(List<String> arguments) async {
  var multSum = await multsSumFromFile(arguments[0]);
  var multSum2 = await multsSumFromFile2(arguments[0]);
  print('Sum of mults: $multSum');
  print('Sum of mults with conds: $multSum2');
}
