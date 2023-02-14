// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$_AccountData {
  List<int> get discriminator => throw UnimplementedError();
  List<int> get owner => throw UnimplementedError();
  List<int> get row_ptrs => throw UnimplementedError();
  List<int> get columns => throw UnimplementedError();
  List<int> get values => throw UnimplementedError();
  int get width => throw UnimplementedError();
  int get height => throw UnimplementedError();
  int get compressed_value => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(8, BU8()).write(writer, discriminator);
    const BFixedArray(32, BU8()).write(writer, owner);
    const BFixedArray(1, BU8()).write(writer, row_ptrs);
    const BFixedArray(1, BU8()).write(writer, columns);
    const BFixedArray(1, BU8()).write(writer, values);
    const BU8().write(writer, width);
    const BU8().write(writer, height);
    const BU8().write(writer, compressed_value);

    return writer.toArray();
  }
}

class __AccountData extends _AccountData {
  __AccountData({
    required this.discriminator,
    required this.owner,
    required this.row_ptrs,
    required this.columns,
    required this.values,
    required this.width,
    required this.height,
    required this.compressed_value,
  }) : super._();

  final List<int> discriminator;
  final List<int> owner;
  final List<int> row_ptrs;
  final List<int> columns;
  final List<int> values;
  final int width;
  final int height;
  final int compressed_value;
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
      row_ptrs: const BFixedArray(1, BU8()).read(reader),
      columns: const BFixedArray(1, BU8()).read(reader),
      values: const BFixedArray(1, BU8()).read(reader),
      width: const BU8().read(reader),
      height: const BU8().read(reader),
      compressed_value: const BU8().read(reader),
    );
  }
}

_AccountData _$_AccountDataFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const B_AccountData().read(reader);
}
