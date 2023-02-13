
import 'dart:convert';
import 'dart:typed_data';

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
    final entityKeyPair = location.id.keyPair!;

    final writer1 = BinaryWriter();
    const BString().write(writer1, "map-location");

    final writer2 = BinaryWriter();
    const BU64().write(writer2, BigInt.from(location.posX));

    final writer3 = BinaryWriter();
    const BU64().write(writer3, BigInt.from(location.posY));


    final pda = await Ed25519HDPublicKey.findProgramAddress(
        seeds: [
          writer1.toArray(),
          owner.getId().publicKey.bytes,
          writer2.toArray(),
          writer3.toArray(),
        ],
        programId: programId,
    );

    await send(
      method: 'init_location',
      params: InitLocation(
        name: location.name,
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
