import 'package:day11/day11.dart' as day11;

void main(List<String> arguments) {
  String input = "0 37551 469 63 1 791606 2065 9983586";
  
  var sc = day11.StonesCounter();
  print('Number of stones 25: ${sc.stonesCountFromString(input, 25)}');
  print('Number of stones 75: ${sc.stonesCountFromString(input, 75)}');
}
