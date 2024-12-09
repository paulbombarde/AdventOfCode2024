import 'package:day9/day9.dart';
import 'package:test/test.dart';

void main() {
  test('generate block file ids 12345', () async {
    String diskMap = "12345";
    expect(await generateBlockFileIds(diskMap).toList(),
        [0, 2, 2, 1, 1, 1, 2, 2, 2]);
  });

  test('generate block file ids 2333133121414131402', () async {
    String diskMap = "2333133121414131402";
    expect(await generateBlockFileIds(diskMap).toList(), [
      0, 0, 9, 9, 8, 1, 1, 1, 8, 8, 8, 2, 7, 7, //
      7, 3, 3, 3, 6, 4, 4, 6, 5, 5, 5, 5, 6, 6
    ]);
  });

  test('generate compacted block file ids', () async {
    String diskMap = "2333133121414131402";
    expect(await generateCompactedBlockFileIds(diskMap).toList(), [
      0, 0, 9, 9, 2, 1, 1, 1, 7, 7, 7, 0, 4, 4, 0, 3, 3, 3, 0, 0, //
      0, 0, 5, 5, 5, 5, 0, 6, 6, 6, 6, 0, 0, 0, 0, 0, 8, 8, 8, 8, 0, 0
    ]);
  });

  test('compute checksum from block file ids', () async {
    var blockFileIds = Stream.fromIterable([
      0, 0, 9, 9, 8, 1, 1, 1, 8, 8, 8, 2, 7, 7, //
      7, 3, 3, 3, 6, 4, 4, 6, 5, 5, 5, 5, 6, 6
    ]);
    expect(await checksumFromBlockFileIds(blockFileIds), 1928);
  });

  test('compute checksum from block file ids 2', () async {
    var blockFileIds = Stream.fromIterable([
      0, 0, 9, 9, 2, 1, 1, 1, 7, 7, 7, 0, 4, 4, 0, 3, 3, 3, 0, 0, //
      0, 0, 5, 5, 5, 5, 0, 6, 6, 6, 6, 0, 0, 0, 0, 0, 8, 8, 8, 8
    ]);
    expect(await checksumFromBlockFileIds(blockFileIds), 2858);
  });
}
