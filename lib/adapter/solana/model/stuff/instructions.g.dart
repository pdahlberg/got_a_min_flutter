// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$InitStuff {
  BigInt get x => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, x);

    return writer.toArray();
  }
}

class _InitStuff extends InitStuff {
  _InitStuff({
    required this.x,
  }) : super._();

  final BigInt x;
}

class BInitStuff implements BType<InitStuff> {
  const BInitStuff();

  @override
  void write(BinaryWriter writer, InitStuff value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  InitStuff read(BinaryReader reader) {
    return InitStuff(
      x: const BU64().read(reader),
    );
  }
}

InitStuff _$InitStuffFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BInitStuff().read(reader);
}
