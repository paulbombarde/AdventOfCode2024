import 'package:day7/day7.dart' as day7;

void main(List<String> arguments) async {
  var sum = await day7.ValidSum.fromFile(arguments[0]);
  print('Sum of valid operations: $sum');
}
