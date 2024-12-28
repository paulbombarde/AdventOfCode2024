import 'package:day23/day23.dart';
import 'package:test/test.dart';

void main() {
  var sample = [
    "kh-tc",
    "qp-kh",
    "de-cg",
    "ka-co",
    "yn-aq",
    "qp-ub",
    "cg-tb",
    "vc-aq",
    "tb-ka",
    "wh-tc",
    "yn-cg",
    "kh-ub",
    "ta-co",
    "de-co",
    "tc-td",
    "tb-wq",
    "wh-td",
    "ta-ka",
    "td-qp",
    "aq-cg",
    "wq-ub",
    "ub-vc",
    "de-ta",
    "wq-aq",
    "wq-vc",
    "wh-yn",
    "ka-de",
    "kh-ta",
    "co-tc",
    "wh-qp",
    "tb-vc",
    "td-yn"
  ];

  test('calculate', () {
    expect(calculateFromLines(sample), 7);
  });

  test('threes', () {
    var n = Network.fromLines(sample);
    var tts = n.threes();
    expect(tts, {
      ("aq", "cg", "yn"),
      ("aq", "vc", "wq"),
      ("co", "de", "ka"),
      ("co", "de", "ta"),
      ("co", "ka", "ta"),
      ("de", "ka", "ta"),
      ("kh", "qp", "ub"),
      ("qp", "td", "wh"),
      ("tb", "vc", "wq"),
      ("tc", "td", "wh"),
      ("td", "wh", "yn"),
      ("ub", "vc", "wq")
    });

    expect(filterTs(tts), {
      ("co", "de", "ta"),
      ("co", "ka", "ta"),
      ("de", "ka", "ta"),
      ("qp", "td", "wh"),
      ("tb", "vc", "wq"),
      ("tc", "td", "wh"),
      ("td", "wh", "yn")
    });

    var lans = n.LANs();
    expect(lans, {
      'kh,tc',
      'kh,qp,ub',
      'cg,de',
      'co,de,ka,ta',
      'aq,cg,yn',
      'cg,tb',
      'aq,vc,wq',
      'tc,td,wh',
      'tb,vc,wq'
    });

    expect(longest(lans), "co,de,ka,ta");
  });
}
