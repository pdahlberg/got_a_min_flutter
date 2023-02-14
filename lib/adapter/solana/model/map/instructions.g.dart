// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$InitMap {
  int get compressed_value => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU8().write(writer, compressed_value);

    return writer.toArray();
  }
}

class _InitMap extends InitMap {
  _InitMap({
    required this.compressed_value,
  }) : super._();

  final int compressed_value;
}

class BInitMap implements BType<InitMap> {
  const BInitMap();

  @override
  void write(BinaryWriter writer, InitMap value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  InitMap read(BinaryReader reader) {
    return InitMap(
      compressed_value: const BU8().read(reader),
    );
  }
}

InitMap _$InitMapFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BInitMap().read(reader);
}
