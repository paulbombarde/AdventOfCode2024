import 'package:day1/day1.dart';

void main(List<String> arguments) async {
  var dist = await totalDistFromFile(arguments[0]);
  var score = await similarityScoreFromFile(arguments[0]);
  print('Total distance: $dist');
  print('Similarity score: $score');
}
