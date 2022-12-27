// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$_AccountData {
  List<int> get discriminator => throw UnimplementedError();
  List<int> get owner => throw UnimplementedError();
  BigInt get occupied_space => throw UnimplementedError();
  BigInt get capacity => throw UnimplementedError();
  String get name => throw UnimplementedError();
  BigInt get position => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(8, BU8()).write(writer, discriminator);
    const BFixedArray(32, BU8()).write(writer, owner);
    const BU64().write(writer, occupied_space);
    const BU64().write(writer, capacity);
    const BString().write(writer, name);
    const BU64().write(writer, position);

    return writer.toArray();
  }
}

class __AccountData extends _AccountData {
  __AccountData({
    required this.discriminator,
    required this.owner,
    required this.occupied_space,
    required this.capacity,
    required this.name,
    required this.position,
  }) : super._();

  final List<int> discriminator;
  final List<int> owner;
  final BigInt occupied_space;
  final BigInt capacity;
  final String name;
  final BigInt position;
}

class B_AccountData implements BType<_AccountData> {
  const B_AccountData();

  @override
  void write(BinaryWriter writer, _AccountData value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  _AccountData read(BinaryReader reader) {
    return _AccountData(
      discriminator: const BFixedArray(8, BU8()).read(reader),
      owner: const BFixedArray(32, BU8()).read(reader),
      occupied_space: const BU64().read(reader),
      capacity: const BU64().read(reader),
      name: const BString().read(reader),
      position: const BU64().read(reader),
    );
  }
}

_AccountData _$_AccountDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const B_AccountData().read(reader);
}
