// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_account.dart';

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

mixin _$Basic1Arguments {
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

class _Basic1Arguments extends Basic1Arguments {
  _Basic1Arguments({
    required this.name,
    required this.position,
    required this.capacity,
  }) : super._();

  final String name;
  final BigInt position;
  final BigInt capacity;
}

class BBasic1Arguments implements BType<Basic1Arguments> {
  const BBasic1Arguments();

  @override
  void write(BinaryWriter writer, Basic1Arguments value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  Basic1Arguments read(BinaryReader reader) {
    return Basic1Arguments(
      name: const BString().read(reader),
      position: const BU64().read(reader),
      capacity: const BU64().read(reader),
    );
  }
}

Basic1Arguments _$Basic1ArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BBasic1Arguments().read(reader);
}

mixin _$TestArguments {
  BigInt get value => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, value);

    return writer.toArray();
  }
}

class _TestArguments extends TestArguments {
  _TestArguments({
    required this.value,
  }) : super._();

  final BigInt value;
}

class BTestArguments implements BType<TestArguments> {
  const BTestArguments();

  @override
  void write(BinaryWriter writer, TestArguments value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  TestArguments read(BinaryReader reader) {
    return TestArguments(
      value: const BU64().read(reader),
    );
  }
}

TestArguments _$TestArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BTestArguments().read(reader);
}
