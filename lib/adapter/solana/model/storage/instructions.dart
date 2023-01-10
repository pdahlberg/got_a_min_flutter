
import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:got_a_min_flutter/adapter/solana/model/invoke_base.dart';
import 'package:got_a_min_flutter/adapter/solana/model/with_to_borsh.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
import 'package:solana/encoder.dart';

part 'instructions.g.dart';

/*
resource_id: Pubkey,
capacity: i64,
mobility_type: MobilityType,
movement_speed: i64,
  */
@BorshSerializable()
class InitStorage with _$InitStorage implements WithToBorsh<InitStorage> {
  factory InitStorage({
    @BFixedArray(32, BU8()) required List<int> resource_id,
    @BU64() required BigInt capacity,
  }) = _InitStorage;

  InitStorage._();

  factory InitStorage.fromBorsh(Uint8List data) => _$InitStorageFromBorsh(data);
}

class InvokeStorageCall extends InvokeBase<InitStorage> {

  InvokeStorageCall(super.client, super.programId, super.owner);

  init(Storage storage) async {
    final entityKeyPair = storage.id.keyPair!;

    debugPrint("InvokeStorageCall.init");

    await send(
      method: 'init_storage',
      params: InitStorage(
        resource_id: storage.resource.id.publicKey.toByteArray().toList(),
        capacity: BigInt.from(storage.capacity),
        //mobility_type: 1,
        //movement_speed: BigInt.from(0),
      ),
      accounts: <AccountMeta>[
        AccountMeta.writeable(pubKey: entityKeyPair.publicKey, isSigner: true),
        //AccountMeta.writeable(pubKey: storage.resource.id.keyPair!.publicKey, isSigner: true),
        //AccountMeta.writeable(pubKey: storage.location.id.keyPair!.publicKey, isSigner: true),
        AccountMeta.writeable(pubKey: owner.keyPair.publicKey, isSigner: true),
      ],
      signers: [
        entityKeyPair,
        owner.keyPair,
      ],
    );
  }

}
