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
  BigInt get pos_x => throw UnimplementedError();
  BigInt get pos_y => throw UnimplementedError();
  int get location_type => throw UnimplementedError();
  String get name => throw UnimplementedError();
  List<int> get occupied_by => throw UnimplementedError();
  int get bump => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(8, BU8()).write(writer, discriminator);
    const BFixedArray(32, BU8()).write(writer, owner);
    const BU64().write(writer, occupied_space);
    const BU64().write(writer, capacity);
    const BU64().write(writer, pos_x);
    const BU64().write(writer, pos_y);
    const BU8().write(writer, location_type);
    const BString().write(writer, name);
    const BFixedArray(10 * (32 * 2), BU8()).write(writer, occupied_by);
    const BU8().write(writer, bump);

    return writer.toArray();
  }
}

class __AccountData extends _AccountData {
  __AccountData({
    required this.discriminator,
    required this.owner,
    required this.occupied_space,
    required this.capacity,
    required this.pos_x,
    required this.pos_y,
    required this.location_type,
    required this.name,
    required this.occupied_by,
    required this.bump,
  }) : super._();

  final List<int> discriminator;
  final List<int> owner;
  final BigInt occupied_space;
  final BigInt capacity;
  final BigInt pos_x;
  final BigInt pos_y;
  final int location_type;
  final String name;
  final List<int> occupied_by;
  final int bump;
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
      pos_x: const BU64().read(reader),
      pos_y: const BU64().read(reader),
      location_type: const BU8().read(reader),
      name: const BString().read(reader),
      occupied_by: const BFixedArray(10 * (32 * 2), BU8()).read(reader),
      bump: const BU8().read(reader),
    );
  }
}

_AccountData _$_AccountDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const B_AccountData().read(reader);
}
