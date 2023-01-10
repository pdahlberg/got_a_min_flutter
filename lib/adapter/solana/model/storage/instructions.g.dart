// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$InitStorage {
  List<int> get resource_id => throw UnimplementedError();
  BigInt get capacity => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(32, BU8()).write(writer, resource_id);
    const BU64().write(writer, capacity);

    return writer.toArray();
  }
}

class _InitStorage extends InitStorage {
  _InitStorage({
    required this.resource_id,
    required this.capacity,
  }) : super._();

  final List<int> resource_id;
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
      resource_id: const BFixedArray(32, BU8()).read(reader),
      capacity: const BU64().read(reader),
    );
  }
}

InitStorage _$InitStorageFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BInitStorage().read(reader);
}
