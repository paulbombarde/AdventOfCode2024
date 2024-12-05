import 'package:day5/day5.dart' as day5;

void main(List<String> arguments) {
  var middleSum = day5.sumOfMiddlesFromFile(arguments[0]);
  print('Sum of valid middles: $middleSum');
}
