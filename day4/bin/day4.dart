import 'package:day4/day4.dart' as day4;

void main(List<String> arguments) {
  var xmasCount = day4.xmasCountFromFile(arguments[0]);
  var x_masCount = day4.countXMasFromFile(arguments[0]);
  print('Number of XMAS: $xmasCount');
  print('Number of X-MAS: $x_masCount');
}
