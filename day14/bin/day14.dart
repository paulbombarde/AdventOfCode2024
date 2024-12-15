import 'package:day14/day14.dart' as day14;
import 'dart:io';

void main(List<String> arguments) {
  var robots = day14.Robots.fromLines(File(arguments[0]).readAsLinesSync());

  var robots100 = robots.move(100, 101, 103);
  print('Safety facor 100: ${robots100.safetyFactor(101, 103)}');
  print('Number of robots: ${robots.robots.length}');

  int c = 0;
  while (true) {
    if (c % 1000 == 0) {
      // display some idea of progress
      print("c: $c");
    }

    // I picked 1000 because the image contains 500 robots
    // If those robots were more or less clustered, most of them would have at least two neighbours.
    if (1000 < robots.coherency()) {
      robots.display(101, 103);
      print('================ $c (${robots.coherency()})');
      sleep(Duration(seconds: 1));
    }
    robots = robots.move(1, 101, 103);
    c++;
  }
}
