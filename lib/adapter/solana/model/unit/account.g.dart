// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$_AccountData {
  List<int> get discriminator => throw UnimplementedError();
  List<int> get owner => throw UnimplementedError();
  List<int> get at_location_id => throw UnimplementedError();
  String get name => throw UnimplementedError();
  BigInt get movement_speed => throw UnimplementedError();
  BigInt get arrives_at => throw UnimplementedError();
  int get bump => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(8, BU8()).write(writer, discriminator);
    const BFixedArray(32, BU8()).write(writer, owner);
    const BFixedArray(32, BU8()).write(writer, at_location_id);
    const BString().write(writer, name);
    const BU64().write(writer, movement_speed);
    const BU64().write(writer, arrives_at);
    const BU8().write(writer, bump);

    return writer.toArray();
  }
}

class __AccountData extends _AccountData {
  __AccountData({
    required this.discriminator,
    required this.owner,
    required this.at_location_id,
    required this.name,
    required this.movement_speed,
    required this.arrives_at,
    required this.bump,
  }) : super._();

  final List<int> discriminator;
  final List<int> owner;
  final List<int> at_location_id;
  final String name;
  final BigInt movement_speed;
  final BigInt arrives_at;
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
      at_location_id: const BFixedArray(32, BU8()).read(reader),
      name: const BString().read(reader),
      movement_speed: const BU64().read(reader),
      arrives_at: const BU64().read(reader),
      bump: const BU8().read(reader),
    );
  }
}

_AccountData _$_AccountDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const B_AccountData().read(reader);
}
