
import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:got_a_min_flutter/adapter/solana/model/with_to_borsh.dart';
import 'package:got_a_min_flutter/adapter/solana/model/invoke_base.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
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

  run(Location location) async {
    final entityKeyPair = location.id.keyPair!;

    await send(
      method: 'init_location',
      params: InitLocation(
        name: location.name,
        position: BigInt.from(location.position),
        capacity: BigInt.from(location.capacity),
      ),
      accounts: <AccountMeta>[
        AccountMeta.writeable(pubKey: entityKeyPair.publicKey, isSigner: true),
        AccountMeta.writeable(pubKey: owner.getId().publicKey, isSigner: true),
      ],
      signers: [
        entityKeyPair,
        owner.getId().keyPair!,
      ],
    );
  }

}
