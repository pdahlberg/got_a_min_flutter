// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructions.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$InitProducer {
  List<int> get resource_id => throw UnimplementedError();
  BigInt get production_rate => throw UnimplementedError();
  BigInt get production_time => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BFixedArray(32, BU8()).write(writer, resource_id);
    const BU64().write(writer, production_rate);
    const BU64().write(writer, production_time);

    return writer.toArray();
  }
}

class _InitProducer extends InitProducer {
  _InitProducer({
    required this.resource_id,
    required this.production_rate,
    required this.production_time,
  }) : super._();

  final List<int> resource_id;
  final BigInt production_rate;
  final BigInt production_time;
}

class BInitProducer implements BType<InitProducer> {
  const BInitProducer();

  @override
  void write(BinaryWriter writer, InitProducer value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  InitProducer read(BinaryReader reader) {
    return InitProducer(
      resource_id: const BFixedArray(32, BU8()).read(reader),
      production_rate: const BU64().read(reader),
      production_time: const BU64().read(reader),
    );
  }
}

InitProducer _$InitProducerFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BInitProducer().read(reader);
}
