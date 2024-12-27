import 'dart:io';

int calculate(String filePath){
  var inputs = File(filePath).readAsLinesSync();
  return calculateFromStrings(inputs);
}

int calculateFromStrings(Iterable<String> inputs){
  var generator = SecretGenerator();
  var intInputs = inputs.map(int.parse);
  var secrets2000 = intInputs.map((s) => generator.nextIter(s, 2000));
  return secrets2000.fold(0, (a,b) => a+b);
}

class SecretGenerator{ 
  int nextIter(int secret, int req){
    int s = secret;
    for(int i=0; i<req; ++i) s = next(s);
    return s;
  }

  int next(int secret){
    int n = prune(mix(secret, secret * 64));
    n = prune(mix(n, n ~/ 32));
    n = prune(mix(n, n * 2048));
    return n;
  }
}

int mix(int secret, int val){
  return secret ^ val;
}

int prune(int secret){
  return secret % 16777216;
}