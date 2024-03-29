// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$InitUnit {
  String get name => throw UnimplementedError();
  BigInt get x => throw UnimplementedError();
  BigInt get y => throw UnimplementedError();
  List<int> get game => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BString().write(writer, name);
    const BU64().write(writer, x);
    const BU64().write(writer, y);
    const BFixedArray(32, BU8()).write(writer, game);

    return writer.toArray();
  }
}

class _InitUnit extends InitUnit {
  _InitUnit({
    required this.name,
    required this.x,
    required this.y,
    required this.game,
  }) : super._();

  final String name;
  final BigInt x;
  final BigInt y;
  final List<int> game;
}

class BInitUnit implements BType<InitUnit> {
  const BInitUnit();

  @override
  void write(BinaryWriter writer, InitUnit value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  InitUnit read(BinaryReader reader) {
    return InitUnit(
      name: const BString().read(reader),
      x: const BU64().read(reader),
      y: const BU64().read(reader),
      game: const BFixedArray(32, BU8()).read(reader),
    );
  }
}

InitUnit _$InitUnitFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BInitUnit().read(reader);
}
