import 'dart:io';
import 'dart:convert';
import 'package:equatable/equatable.dart';

Future<int> calculate(String filePath) async{
  var lines = linesFromFile(filePath);
  return numberFittingPairsFromLines(lines);
}

typedef BlockValues = List<int>;
typedef Key = BlockValues;
typedef Lock = BlockValues;
typedef Keys = Set<Key>;
typedef Locks = Set<Lock>;

Future<int> numberFittingPairsFromLines(Stream<String> lines) async {
  var blocks = blocksFromLines(lines);
  var blocksData = blocksDataFromBlocks(blocks);
  return klFromBlockData(blocksData).then((kl) => numberFittingPairs(kl.$1, kl.$2));
}

int numberFittingPairs(Keys keys, Locks locks){
  return keys.fold(0, (a, key) => a + numberFittingLocks(key, locks));
}

int numberFittingLocks(Key key, Locks locks){
  return locks.fold(0, (a, lock) => a + keyFitsLock(key, lock));
}

int keyFitsLock(Key key, Lock lock){
  for(int i=0; i<key.length; ++i){
    if(key[i] < lock[i]) return 0;
  }
  return 1;
}

Future<(Keys, Locks)> klFromBlockData(Stream<BlockData> blocksData) async{
  var keys = Keys();
  var locks = Locks();
  await for(var b in blocksData){
    if(b.t == Type.Key) keys.add(b.v);
    else locks.add(b.v);
  }
  return (keys, locks);
}

enum Type{Key, Lock}
class BlockData extends Equatable {
  final Type t;
  final BlockValues v; // for lock, the numbers of #, for keys, the number of .

  @override
  List<Object> get props => [t, v];

  const BlockData(this.t, this.v);
  factory BlockData.fromBlock(Block b){
    var ref = b[0][0];
    var t = ref == "."?Type.Key:Type.Lock;

    var columnSize = (int c) {
      var acc = (int a, String l) => a + ((l[c] == ref)?1:0);
      return b.fold(0, acc);
    };

    var v = [for(int c=0; c<b[0].length; ++c) columnSize(c)];
    return BlockData(t, v);
  }
}

Stream<BlockData> blocksDataFromBlocks(Stream<Block> blocks){
  return blocks.map(BlockData.fromBlock);
}


typedef Block = List<String>;
Stream<Block> blocksFromLines(Stream<String> lines) async*{
  var block = <String>[];
  await for(var l in lines){
    if(l.length == 0){
      yield block;
      block = <String>[];
    }
    else{
      block.add(l);
    }
  }
  if(0 < block.length){
    yield block;
  }
}

Stream<String> linesFromFile(String filePath) {
  return File(filePath)
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter());
}
