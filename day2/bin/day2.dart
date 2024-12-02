import 'package:day2/day2.dart';

void main(List<String> arguments) async {
  var safeCount = await safeCountFromFile(arguments[0], isSafe);
  var safeCount2 = await safeCountFromFile(arguments[0], isSafe2);
  print("Number of safe reports: $safeCount");
  print("Number of safe reports with dampening: $safeCount2");
}
