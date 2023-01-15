
import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:got_a_min_flutter/adapter/solana/model/invoke_base.dart';
import 'package:got_a_min_flutter/adapter/solana/model/with_to_borsh.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
import 'package:solana/encoder.dart';

part 'instructions.g.dart';

@BorshSerializable()
class InitProducer with _$InitProducer implements WithToBorsh<InitProducer> {
  factory InitProducer({
    @BFixedArray(32, BU8()) required List<int> resource_id,
    @BU64() required BigInt production_rate,
    @BU64() required BigInt production_time,
  }) = _InitProducer;

  InitProducer._();

  factory InitProducer.fromBorsh(Uint8List data) => _$InitProducerFromBorsh(data);
}

class InvokeProducerCall extends InvokeBase<InitProducer> {

  InvokeProducerCall(super.client, super.programId, super.owner);

  init(Producer producer) async {
    final entityKeyPair = producer.id.keyPair!;

    debugPrint("InvokeProducerCall.init");

    await send(
      method: 'init_producer',
      params: InitProducer(
        resource_id: producer.resource.id.publicKey.toByteArray().toList(),
        production_rate: BigInt.from(producer.productionRate),
        production_time: BigInt.from(producer.productionTime),
      ),
      accounts: <AccountMeta>[
        AccountMeta.writeable(pubKey: entityKeyPair.publicKey, isSigner: true),
        AccountMeta.writeable(pubKey: producer.location.id.keyPair!.publicKey, isSigner: true),
        AccountMeta.writeable(pubKey: owner.keyPair.publicKey, isSigner: true),
      ],
      signers: [
        entityKeyPair,
        producer.location.id.keyPair!,
        owner.keyPair,
      ],
    );
  }

  produce(Producer producer, Storage storage) async {
    final entityKeyPair = producer.id.keyPair!;
    var resource = producer.resource;

    debugPrint("InvokeProducerCall.produce");

    try {
      await send(
        method: 'produce_without_input',
        accounts: <AccountMeta>[
          AccountMeta.writeable(pubKey: entityKeyPair.publicKey, isSigner: false),
          AccountMeta.writeable(pubKey: resource.id.keyPair!.publicKey, isSigner: false),
          AccountMeta.writeable(pubKey: storage.id.keyPair!.publicKey, isSigner: false),
          AccountMeta.writeable(pubKey: owner.keyPair.publicKey, isSigner: true),
        ],
        signers: [
          owner.keyPair,
        ],
      );
    } catch (e) {
      debugPrint("Error: $e");
    }

  }

}
