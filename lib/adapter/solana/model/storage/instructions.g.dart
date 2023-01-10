// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$InitStorage {
  BigInt get capacity => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, capacity);

    return writer.toArray();
  }
}

class _InitStorage extends InitStorage {
  _InitStorage({
    required this.capacity,
  }) : super._();

  final BigInt capacity;
}

class BInitStorage implements BType<InitStorage> {
  const BInitStorage();

  @override
  void write(BinaryWriter writer, InitStorage value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  InitStorage read(BinaryReader reader) {
    return InitStorage(
      capacity: const BU64().read(reader),
    );
  }
}

InitStorage _$InitStorageFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BInitStorage().read(reader);
}
