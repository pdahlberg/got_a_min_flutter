// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$InitResource {
  String get name => throw UnimplementedError();
  List<int> get input1 => throw UnimplementedError();
  List<int> get input2 => throw UnimplementedError();
  BigInt get input_amount1 => throw UnimplementedError();
  BigInt get input_amount2 => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BString().write(writer, name);
    const BFixedArray(32, BU8()).write(writer, input1);
    const BFixedArray(32, BU8()).write(writer, input2);
    const BU64().write(writer, input_amount1);
    const BU64().write(writer, input_amount2);

    return writer.toArray();
  }
}

class _InitResource extends InitResource {
  _InitResource({
    required this.name,
    required this.input1,
    required this.input2,
    required this.input_amount1,
    required this.input_amount2,
  }) : super._();

  final String name;
  final List<int> input1;
  final List<int> input2;
  final BigInt input_amount1;
  final BigInt input_amount2;
}

class BInitResource implements BType<InitResource> {
  const BInitResource();

  @override
  void write(BinaryWriter writer, InitResource value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  InitResource read(BinaryReader reader) {
    return InitResource(
      name: const BString().read(reader),
      input1: const BFixedArray(32, BU8()).read(reader),
      input2: const BFixedArray(32, BU8()).read(reader),
      input_amount1: const BU64().read(reader),
      input_amount2: const BU64().read(reader),
    );
  }
}

InitResource _$InitResourceFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BInitResource().read(reader);
}
