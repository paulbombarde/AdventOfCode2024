import 'package:day9/day9.dart' as day9;

void main(List<String> arguments) async {
  day9.checksumFromFile(arguments[0]).then((s) => print('checksum: $s'));
}
