import 'package:day12/day12.dart' as day12;

void main(List<String> arguments) {
  var zc = day12.ZonesMap.fromFile(arguments[0]);
  print('Total fence cost: ${zc.fenceCost()}');
}
