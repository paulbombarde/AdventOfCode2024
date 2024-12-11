class StonesCounter {
  var cache = <(int, int), int>{};

  int stonesCountFromString(String input, int iter) {
    var stones = [for (var v in input.split(' ')) int.parse(v)];
    return stonesCountFromStones(stones, iter);
  }

  int stonesCountFromStones(List<int> stones, int iter) {
    return stones.fold(0, (acc, stone) => acc + stonesCountFromStone(stone, iter));
  }

  int stonesCountFromStone(int stone, int iter) {
    if (iter == 0) return 1;

    if(cache.containsKey((stone, iter))){
      return cache[(stone, iter)]!;
    }

    int res = stoneChange(stone).fold(0, (acc, next) => acc + stonesCountFromStone(next, iter-1));
    cache[(stone, iter)] = res;
    return res;
  }
}

List<int> stoneChange(int stone) {
  if (stone == 0) {
    return [1];
  }

  int n = 1;
  int fact = 10;
  while (fact <= stone) {
    n += 1;
    fact *= 10;
  }

  if (n % 2 == 0) {
    n = n ~/ 2;
    fact = 1;
    while (0 != n) {
      fact *= 10;
      n--;
    }
    return [stone ~/ fact, stone % fact];
  }

  return [stone * 2024];
}
