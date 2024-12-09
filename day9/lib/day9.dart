import 'dart:io';

Future<(int, int)> checksumFromFile(String filePath) async {
  var diskMap = File(filePath).readAsLinesSync()[0];
  var blockFileIds = generateBlockFileIds(diskMap);
  var compactedBlockFileIds = generateCompactedBlockFileIds(diskMap);
  var checksum = await checksumFromBlockFileIds(blockFileIds);
  var compactedChecksum = await checksumFromBlockFileIds(compactedBlockFileIds);
  return (checksum, compactedChecksum);
}

Stream<int> generateBlockFileIds(String diskMap) async* {
  int end = diskMap.length + 1;
  int remainingAtEnd = 0;

  for (int i = 0; i < end; ++i) {
    int remainingAtBeg = int.parse(diskMap[i]);
    if (0 == i % 2) {
      int fileId = (i / 2).floor();
      while (0 < remainingAtBeg) {
        yield fileId;
        remainingAtBeg--;
      }
    } else {
      while (0 < remainingAtBeg) {
        if (0 == remainingAtEnd) {
          end -= 2;
          if (end <= i) break;
          remainingAtEnd = int.parse(diskMap[end]);
        }
        yield (end / 2).floor();
        remainingAtEnd--;
        remainingAtBeg--;
      }
    }
  }

  while (0 < remainingAtEnd) {
    yield (end / 2).floor();
    remainingAtEnd--;
  }
}

Stream<int> generateCompactedBlockFileIds(String diskMap) async* {
  // Start by creating a list of block data
  // each block contains (fileId, size), with fileId = -1 if empty space.

  var blockData = <(int, int)>[];
  for (int i = 0; i < diskMap.length; ++i) {
    int fileId = (0 != i % 2) ? -1 : (i / 2).floor();
    blockData.add((fileId, int.parse(diskMap[i])));
  }

  // Try to move non empty block from end to begin
  for (int end = blockData.length - 1; 0 <= end; --end) {
    // Skip empty space
    if (blockData[end].$1 == -1) continue;

    var (endFileId, endBlockSize) = blockData[end];
    for (int i = 0; i < end; ++i) {
      // Not empty place
      if (blockData[i].$1 != -1) continue;
      // Not enough place
      if (blockData[i].$2 < endBlockSize) continue;

      var emptySize = blockData[i].$2;

      // Mark end block as empty
      blockData[end] = (-1, endBlockSize);
      // Move end block in position
      blockData[i] = (endFileId, endBlockSize);

      // Add empty block for remaining empty space
      if (endBlockSize < emptySize) {
        blockData.insert(i+1,
            (-1, emptySize - endBlockSize));
        ++end; // compensate for added block.
      }

      break;
    }
  }

  // Convert blocks to file indexes
  for (int i=0; i<blockData.length; ++i) {
    var id = blockData[i].$1;
    if(id == -1) id = 0;
    for(int j=0; j<blockData[i].$2; ++j) {
      yield id;
    }
  }
}

Future<int> checksumFromBlockFileIds(Stream<int> blockFileIds) async {
  int i = 0;
  int res = 0;
  await for (var bfi in blockFileIds) {
    res += i * bfi;
    ++i;
  }
  return res;
}
