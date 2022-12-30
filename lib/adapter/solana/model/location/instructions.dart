
import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:got_a_min_flutter/adapter/solana/model/with_to_borsh.dart';
import 'package:got_a_min_flutter/adapter/solana/model/invoke_base.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:solana/anchor.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

part 'instructions.g.dart';

@BorshSerializable()
class InitLocation with _$InitLocation implements WithToBorsh<InitLocation> {
  factory InitLocation({
    @BString() required String name,
    @BU64() required BigInt position,
    @BU64() required BigInt capacity,
  }) = _InitLocation;

  InitLocation._();

  factory InitLocation.fromBorsh(Uint8List data) => _$InitLocationFromBorsh(data);
}

class InvokeInitLocation extends InvokeBase<InitLocation> {

  InvokeInitLocation(super.client, super.programId, super.owner);

  run(Item location) async {
    final entityKeyPair = location.id.keyPair!;

    await send(
      method: 'init_location',
      params: InitLocation(
        name: "name",
        position: BigInt.from(100),
        capacity: BigInt.from(100),
      ),
      accounts: <AccountMeta>[
        AccountMeta.writeable(pubKey: entityKeyPair.publicKey, isSigner: true),
        AccountMeta.writeable(pubKey: owner.keyPair.publicKey, isSigner: true),
      ],
      signers: [
        entityKeyPair,
        owner.keyPair,
      ],
    );
  }

}
