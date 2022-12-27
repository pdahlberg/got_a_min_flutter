// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_account.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$_AccountData {
  List<int> get discriminator => throw UnimplementedError();
  BigInt get number => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(8, BU8()).write(writer, discriminator);
    const BU64().write(writer, number);

    return writer.toArray();
  }
}

class __AccountData extends _AccountData {
  __AccountData({
    required this.discriminator,
    required this.number,
  }) : super._();

  final List<int> discriminator;
  final BigInt number;
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
      number: const BU64().read(reader),
    );
  }
}

_AccountData _$_AccountDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const B_AccountData().read(reader);
}

mixin _$TestArguments {
  BigInt get number => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, number);

    return writer.toArray();
  }
}

class _TestArguments extends TestArguments {
  _TestArguments({
    required this.number,
  }) : super._();

  final BigInt number;
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
      number: const BU64().read(reader),
    );
  }
}

TestArguments _$TestArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BTestArguments().read(reader);
}
