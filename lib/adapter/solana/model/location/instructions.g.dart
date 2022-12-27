// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$InitLocation {
  String get name => throw UnimplementedError();
  BigInt get position => throw UnimplementedError();
  BigInt get capacity => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BString().write(writer, name);
    const BU64().write(writer, position);
    const BU64().write(writer, capacity);

    return writer.toArray();
  }
}

class _InitLocation extends InitLocation {
  _InitLocation({
    required this.name,
    required this.position,
    required this.capacity,
  }) : super._();

  final String name;
  final BigInt position;
  final BigInt capacity;
}

class BInitLocation implements BType<InitLocation> {
  const BInitLocation();

  @override
  void write(BinaryWriter writer, InitLocation value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  InitLocation read(BinaryReader reader) {
    return InitLocation(
      name: const BString().read(reader),
      position: const BU64().read(reader),
      capacity: const BU64().read(reader),
    );
  }
}

InitLocation _$InitLocationFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BInitLocation().read(reader);
}
