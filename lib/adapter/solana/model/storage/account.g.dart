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
  BigInt get amount => throw UnimplementedError();
  BigInt get capacity => throw UnimplementedError();
  String get mobilityType => throw UnimplementedError();
  BigInt get movementSpeed => throw UnimplementedError();
  BigInt get arrivesAt => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(8, BU8()).write(writer, discriminator);
    const BFixedArray(32, BU8()).write(writer, owner);
    const BFixedArray(32, BU8()).write(writer, resourceId);
    const BFixedArray(32, BU8()).write(writer, locationId);
    const BU64().write(writer, amount);
    const BU64().write(writer, capacity);
    const BString().write(writer, mobilityType);
    const BU64().write(writer, movementSpeed);
    const BU64().write(writer, arrivesAt);

    return writer.toArray();
  }
}

class __AccountData extends _AccountData {
  __AccountData({
    required this.discriminator,
    required this.owner,
    required this.resourceId,
    required this.locationId,
    required this.amount,
    required this.capacity,
    required this.mobilityType,
    required this.movementSpeed,
    required this.arrivesAt,
  }) : super._();

  final List<int> discriminator;
  final List<int> owner;
  final List<int> resourceId;
  final List<int> locationId;
  final BigInt amount;
  final BigInt capacity;
  final String mobilityType;
  final BigInt movementSpeed;
  final BigInt arrivesAt;
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
      amount: const BU64().read(reader),
      capacity: const BU64().read(reader),
      mobilityType: const BString().read(reader),
      movementSpeed: const BU64().read(reader),
      arrivesAt: const BU64().read(reader),
    );
  }
}

_AccountData _$_AccountDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const B_AccountData().read(reader);
}
