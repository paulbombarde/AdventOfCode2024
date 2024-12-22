import 'dart:io';

int calculate(String filePath) {
  var lines = File(filePath).readAsLinesSync();
  var r = Reader.fromLines(lines);
  return r.nbValid();
}

class Reader {
  var patterns = <String>{};
  var designs = <String>[];

  Reader(this.patterns, this.designs);
  factory Reader.fromLines(List<String> lines) {
    return Reader(lines[0].split(', ').toSet(), lines.sublist(2));
  }

  int nbValid(){
    var dv = DesignValidator(patterns);
    int n = 0;
    for(var design in designs){
      if(dv.isValid(design)) n++;
    }
    return n;
  }
}

class DesignValidator {
  var patterns = <String>{};
  
  DesignValidator(this.patterns);

  bool isValid(String design){
    var offsets=[0];
    var seen = <int>{0};
    while(!offsets.isEmpty){
      var offset = offsets.removeLast();
      seen.add(offset);
      for(var pattern in patterns){
        var next = offset + pattern.length;
        if(seen.contains(next)) continue;
        if(!matches(design, offset, pattern)) continue;
        if(next == design.length) return true;
        offsets.add(next);
      }
    }
    return false;
  }

  bool matches(String design, int offset, String pattern){
    if(design.length < offset + pattern.length) return false;
    for(int i=0; i<pattern.length; ++i){
      if(design[offset+i] != pattern[i]) return false;
    }
    return true;
  }
}
