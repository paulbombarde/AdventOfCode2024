import 'dart:io';

typedef Update = List<int>;

(int, int) sumOfMiddlesFromFile(String filePath){
  var lines = readLines(filePath);
  return sumOfMiddles(lines); 
}

(int, int) sumOfMiddles(List<String> lines){
  var c = Comparator();
  int i=0;
  for(; i<lines.length; ++i) {
    if(lines[i].isEmpty) break;
    c.addRuleFromString(lines[i]);
  }

  int valids = 0;
  int fixed = 0;
  for(++i; i<lines.length; ++i) {
    var u = updateFromString(lines[i]);
    if(c.validate(u)) {
      valids += middle(u);
    }
    else {
      var u2 = c.fix(u);
      fixed += middle(u2);
    }
  }
  
  return (valids, fixed);
}

class Comparator {
  Map<int, Set<int>> rules = {};

  void addRulesFromStrings(List<String> rules) {
    for (var r in rules) {
      addRuleFromString(r);
    }
  }

  void addRuleFromString(String rule) {
    var elems = rule.split('|');
    addRule(int.parse(elems[0]), int.parse(elems[1]));
  }

  void addRule(int before, int after) {
    if (!rules.containsKey(before)) {
      rules[before] = {};
    }
    rules[before]!.add(after);
  }

  bool validate(Update r) {
    for (int i = 1; i < r.length; ++i) {
      if (0 < compare(r[i - 1], r[i])) return false;
    }
    return true;
  }

  int compare(int a, int b) {
    if (rules.containsKey(a) && rules[a]!.contains(b)) return -1;
    if (rules.containsKey(b) && rules[b]!.contains(a)) return 1;
    return 0;
  }

  Update fix(Update u){
    u.sort((a, b) => compare(a, b));
    return u;
  }
}

Update updateFromString(String line)
{
  return [for (final v in line.split(',')) int.parse(v)];
}

int middle(Update u)
{
  return u[u.length ~/2];
}

List<String> readLines(String filePath){
  return File(filePath).readAsLinesSync();
}