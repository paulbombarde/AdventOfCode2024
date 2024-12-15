import 'dart:math';

import 'package:day14/day14.dart';
import 'package:test/test.dart';

void main() {
  var sample = [
    "p=0,4 v=3,-3",
    "p=6,3 v=-1,-3",
    "p=10,3 v=-1,2",
    "p=2,0 v=2,-1",
    "p=0,0 v=1,3",
    "p=3,0 v=-2,-2",
    "p=7,6 v=-1,-3",
    "p=3,0 v=-1,-2",
    "p=9,3 v=2,3",
    "p=7,3 v=-1,2",
    "p=2,4 v=2,-3",
    "p=9,5 v=-3,-3"
  ];

  var sampleRobots = [
    Robot(0, 4, 3, -3),
    Robot(6, 3, -1, -3),
    Robot(10, 3, -1, 2),
    Robot(2, 0, 2, -1),
    Robot(0, 0, 1, 3),
    Robot(3, 0, -2, -2),
    Robot(7, 6, -1, -3),
    Robot(3, 0, -1, -2),
    Robot(9, 3, 2, 3),
    Robot(7, 3, -1, 2),
    Robot(2, 4, 2, -3),
    Robot(9, 5, -3, -3)
  ];

    var movedSample = Robots([
      Robot(3, 5, 3, -3),
      Robot(5, 4, -1, -3),
      Robot(9, 0, -1, 2),
      Robot(4, 5, 2, -1),
      Robot(1, 6, 1, 3),
      Robot(1, 3, -2, -2),
      Robot(6, 0, -1, -3),
      Robot(2, 3, -1, -2),
      Robot(0, 2, 2, 3),
      Robot(6, 0, -1, 2),
      Robot(4, 5, 2, -3),
      Robot(6, 6, -3, -3)
    ]);

  test('robot from line', () {
    expect(Robot.fromLine("p=0,4 v=3,-3"), Robot(0, 4, 3, -3));
  });

  test('robots from lines', () {
    expect(Robots.fromLines(sample), Robots(sampleRobots));
  });

  test('move robot', () {
    var r = Robot(2, 4, 2, -3);
    expect(r.move(1, 11, 7), Robot(4, 1, 2, -3));
    expect(r.move(2, 11, 7), Robot(6, 5, 2, -3));
    expect(r.move(3, 11, 7), Robot(8, 2, 2, -3));
    expect(r.move(4, 11, 7), Robot(10, 6, 2, -3));
    expect(r.move(5, 11, 7), Robot(1, 3, 2, -3));
  });

  test('move robots', () {
    var rs = Robots(sampleRobots);
    expect(rs.move(100, 11, 7), movedSample);
  });

  test('robots in zone', (){
    var r = Robot(0, 2, 2, 3);
    expect(r.isIn(0, 4, 0, 5), true);
    expect(r.isIn(0, 4, 7, 11), false);
    expect(r.isIn(6, 9, 7, 11), false);
    expect(r.isIn(6, 9, 0, 5), false);

    var r2 = Robot(4, 5, 2, -3);
    expect(r2.isIn(0, 4, 0, 5), false);
    expect(r2.isIn(0, 4, 7, 11), false);
    expect(r2.isIn(6, 9, 7, 11), false);
    expect(r2.isIn(6, 9, 0, 5), false);
  });

  test('count robots in zone', (){
    expect(movedSample.countIn(0, 5, 0, 3), 1);
    expect(movedSample.countIn(6, 11, 0, 3), 3);
    expect(movedSample.countIn(0, 5, 4, 7), 4);
    expect(movedSample.countIn(6, 11, 4, 7), 1);
  });

  test('safety factor', (){
    expect(movedSample.safetyFactor(11, 7), 12);
  });
}
