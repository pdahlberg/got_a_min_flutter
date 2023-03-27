
import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:got_a_min_flutter/adapter/solana/model/invoke_base.dart';
import 'package:got_a_min_flutter/adapter/solana/model/with_to_borsh.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

part 'instructions.g.dart';

@BorshSerializable()
class InitLocation with _$InitLocation implements WithToBorsh<InitLocation> {
  factory InitLocation({
    @BU64() required BigInt pos_x,
    @BU64() required BigInt pos_y,
    @BU64() required BigInt capacity,
    @BU8() required int location_type,
  }) = _InitLocation;

  InitLocation._();

  factory InitLocation.fromBorsh(Uint8List data) => _$InitLocationFromBorsh(data);
}

class InvokeInitLocation extends InvokeBase<InitLocation> {

  InvokeInitLocation(super.client, super.programId, super.owner);

  run(Location location) async {
    debugPrint("x: ${location.posX}, y: ${location.posY}");

    final pda = await Ed25519HDPublicKey.findProgramAddress(
        seeds: [
          stringBytes("map-location"),
          owner.getId().publicKey.bytes,
          i64Bytes(location.posX),
          i64Bytes(location.posY),
        ],
        programId: programId,
    );

    await send(
      method: 'init_location',
      params: InitLocation(
        pos_x: BigInt.from(location.posX),
        pos_y: BigInt.from(location.posY),
        capacity: BigInt.from(location.capacity),
        location_type: location.type.index,
      ),
      accounts: <AccountMeta>[
        AccountMeta.writeable(pubKey: pda, isSigner: false),
        AccountMeta.writeable(pubKey: owner.getId().publicKey, isSigner: true),
      ],
      signers: [
        owner.getId().keyPair!,
      ],
    );
  }

}
