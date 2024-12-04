import 'dart:io';

int xmasCountFromFile(String filePath){
  var lines = readLines(filePath);
  return xmasCount(lines);
}

int countXMasFromFile(String filePath){
  var lines = readLines(filePath);
  return countXMas(lines);
}

List<String> readLines(String filePath) {
  var f = File(filePath);
  return f.readAsLinesSync();
}

int xmasCount(List<String> input) {
  int res = 0;
  for (int x = 0; x < input.length; ++x) {
    for (int y = 0; y < input[x].length; ++y) {
      res += xmasCountAt(input, x, y);
    }
  }
  return res;
}

int xmasCountAt(List<String> input, int x, int y)
{
  if(input[x][y] != "X") return 0;

  var res = 0;
  for(int dx=-1; dx<=1; ++dx){
    for(int dy=-1; dy<=1; ++dy){
      if(dx != 0 || dy != 0){
        res += xmasCountDir(input, x, y, dx, dy);
      }
    }
  }
  return res;
}

int xmasCountDir(List<String> input, int x, int y, int dx, int dy)
{
  const xmas = "XMAS";
  for(int i=0; i<xmas.length; ++i)
  {
    var x1 = x + i*dx;
    var y1 = y + i*dy;

    if(x1 < 0 || input.length <= x1 || y1 < 0 || input[x1].length <= y1 ) {
      return 0;
    }

    if(input[x1][y1] != xmas[i]) {
      return 0;
    }
  }
  return 1;
}

int countXMas(List<String> input) {
  int res = 0;
  for (int x = 1; x < input.length-1; ++x) {
    for (int y = 1; y < input[x].length-1; ++y) {
      res += isXMas(input, x, y);
    }
  }
  return res;
}

int isXMas(List<String> input, int x, int y){
  if(input[x][y] != "A") return 0;

  int res =isXMasDir(input, x, y, -1, -1);
  res +=isXMasDir(input, x, y, 1, -1);
  res +=isXMasDir(input, x, y, 1, 1);
  res +=isXMasDir(input, x, y, -1, 1);

  return (res == 2)?1:0;
}

int isXMasDir(List<String> input, int x, int y, int dx, int dy){
  return (input[x+dx][y+dy] == "M" && input[x-dx][y-dy] == "S")?1:0;
}