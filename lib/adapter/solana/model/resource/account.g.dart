// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$_AccountData {
  List<int> get discriminator => throw UnimplementedError();
  List<int> get owner => throw UnimplementedError();
  String get name => throw UnimplementedError();
  List<int> get input1 => throw UnimplementedError();
  List<int> get input2 => throw UnimplementedError();
  BigInt get input_amount1 => throw UnimplementedError();
  BigInt get input_amount2 => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(8, BU8()).write(writer, discriminator);
    const BFixedArray(32, BU8()).write(writer, owner);
    const BString().write(writer, name);
    const BFixedArray(32, BU8()).write(writer, input1);
    const BFixedArray(32, BU8()).write(writer, input2);
    const BU64().write(writer, input_amount1);
    const BU64().write(writer, input_amount2);

    return writer.toArray();
  }
}

class __AccountData extends _AccountData {
  __AccountData({
    required this.discriminator,
    required this.owner,
    required this.name,
    required this.input1,
    required this.input2,
    required this.input_amount1,
    required this.input_amount2,
  }) : super._();

  final List<int> discriminator;
  final List<int> owner;
  final String name;
  final List<int> input1;
  final List<int> input2;
  final BigInt input_amount1;
  final BigInt input_amount2;
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
      name: const BString().read(reader),
      input1: const BFixedArray(32, BU8()).read(reader),
      input2: const BFixedArray(32, BU8()).read(reader),
      input_amount1: const BU64().read(reader),
      input_amount2: const BU64().read(reader),
    );
  }
}

_AccountData _$_AccountDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const B_AccountData().read(reader);
}
