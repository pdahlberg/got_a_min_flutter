// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$_AccountData {
  List<int> get discriminator => throw UnimplementedError();
  List<int> get owner => throw UnimplementedError();
  List<int> get resourceId => throw UnimplementedError();
  List<int> get locationId => throw UnimplementedError();
  BigInt get production_rate => throw UnimplementedError();
  BigInt get production_time => throw UnimplementedError();
  BigInt get awaiting_units => throw UnimplementedError();
  BigInt get claimed_at => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(8, BU8()).write(writer, discriminator);
    const BFixedArray(32, BU8()).write(writer, owner);
    const BFixedArray(32, BU8()).write(writer, resourceId);
    const BFixedArray(32, BU8()).write(writer, locationId);
    const BU64().write(writer, production_rate);
    const BU64().write(writer, production_time);
    const BU64().write(writer, awaiting_units);
    const BU64().write(writer, claimed_at);

    return writer.toArray();
  }
}

class __AccountData extends _AccountData {
  __AccountData({
    required this.discriminator,
    required this.owner,
    required this.resourceId,
    required this.locationId,
    required this.production_rate,
    required this.production_time,
    required this.awaiting_units,
    required this.claimed_at,
  }) : super._();

  final List<int> discriminator;
  final List<int> owner;
  final List<int> resourceId;
  final List<int> locationId;
  final BigInt production_rate;
  final BigInt production_time;
  final BigInt awaiting_units;
  final BigInt claimed_at;
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
      resourceId: const BFixedArray(32, BU8()).read(reader),
      locationId: const BFixedArray(32, BU8()).read(reader),
      production_rate: const BU64().read(reader),
      production_time: const BU64().read(reader),
      awaiting_units: const BU64().read(reader),
      claimed_at: const BU64().read(reader),
    );
  }
}

_AccountData _$_AccountDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const B_AccountData().read(reader);
}
