import 'package:day13/day13.dart' as day13;

void main(List<String> arguments) async {
  print('Tokens: ${await day13.minTokensFromFile(arguments[0])}!');
}
