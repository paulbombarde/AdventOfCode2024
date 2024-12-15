import 'dart:io';
import 'package:equatable/equatable.dart';

int safetyFactor(String filePath) {
  var robots = Robots.fromLines(File(filePath).readAsLinesSync());
  var robots100 = robots.move(100, 101, 103);
  return robots100.safetyFactor(101, 103);
}

class Robot extends Equatable {
  final int x;
  final int y;
  final int vx;
  final int vy;

  @override
  List<Object> get props => [x, y, vx, vy];

  Robot(this.x, this.y, this.vx, this.vy);
  factory Robot.fromLine(String line) {
    var s = line.split(" ");
    var p = s[0].substring(2).split(',');
    var v = s[1].substring(2).split(',');
    return Robot(
        int.parse(p[0]), int.parse(p[1]), int.parse(v[0]), int.parse(v[1]));
  }

  Robot move(int n, int H, int L) {
    return Robot((x + n * vx) % H, (y + n * vy) % L, vx, vy);
  }

  bool isIn(num xmin, num xmax, num ymin, num ymax) {
    return xmin <= x && x < xmax && ymin <= y && y < ymax;
  }
}

class Robots extends Equatable {
  final List<Robot> robots;

  @override
  List<Object> get props => [robots];

  Robots(this.robots);
  Robots.fromLines(Iterable<String> lines)
      : this(lines.map(Robot.fromLine).toList());

  Robots move(int n, int H, int L) {
    return Robots([for (var r in robots) r.move(n, H, L)]);
  }

  int countIn(num xmin, num xmax, num ymin, num ymax) {
    int c = 0;
    for (var r in robots) {
      if (r.isIn(xmin, xmax, ymin, ymax)) c++;
    }
    return c;
  }

  int safetyFactor(int H, int L) {
    int sx = H ~/ 2;
    int sy = L ~/ 2;
    return countIn(0, sx, 0, sy) *
        countIn(sx + 1, H, 0, sy) *
        countIn(0, sx, sy + 1, L) *
        countIn(sx + 1, H, sy + 1, L);
  }
}
