// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$InitLocation {
  BigInt get pos_x => throw UnimplementedError();
  BigInt get pos_y => throw UnimplementedError();
  BigInt get capacity => throw UnimplementedError();
  int get location_type => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, pos_x);
    const BU64().write(writer, pos_y);
    const BU64().write(writer, capacity);
    const BU8().write(writer, location_type);

    return writer.toArray();
  }
}

class _InitLocation extends InitLocation {
  _InitLocation({
    required this.pos_x,
    required this.pos_y,
    required this.capacity,
    required this.location_type,
  }) : super._();

  final BigInt pos_x;
  final BigInt pos_y;
  final BigInt capacity;
  final int location_type;
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
      pos_x: const BU64().read(reader),
      pos_y: const BU64().read(reader),
      capacity: const BU64().read(reader),
      location_type: const BU8().read(reader),
    );
  }
}

InitLocation _$InitLocationFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BInitLocation().read(reader);
}
