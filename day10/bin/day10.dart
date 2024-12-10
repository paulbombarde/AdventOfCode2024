import 'dart:io';
import 'dart:core';
import 'package:day10/day10.dart' as day10;

void main(List<String> arguments) async {
  var lines = File(arguments[0]).readAsLinesSync();
  var topo = day10.Topo.fromStrings(lines);

  {
    var sw1 = Stopwatch()..start();
    var score1 = topo.computeMapScore();
    var e1 = sw1.elapsed;
    print('Map score 1: ${score1}, ${e1}');
  }

  {
    var sw2 = Stopwatch()..start();
    var score2 = await topo.computeMapScoreParallel();
    var e2 = sw2.elapsed;
    print('Map score 2: ${score2}, ${e2}');
  }
}
