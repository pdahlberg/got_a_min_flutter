
import 'dart:convert';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:got_a_min_flutter/adapter/solana/model/invoke_base.dart';
import 'package:got_a_min_flutter/adapter/solana/model/with_to_borsh.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

part 'instructions.g.dart';

@BorshSerializable()
class InitUnit with _$InitUnit implements WithToBorsh<InitUnit> {
  factory InitUnit({
    @BString() required String name,
    @BU64() required BigInt x,
    @BU64() required BigInt y,
  }) = _InitUnit;

  InitUnit._();

  factory InitUnit.fromBorsh(Uint8List data) => _$InitUnitFromBorsh(data);
}

class InvokeUnitCall extends InvokeBase<InitUnit> {

  InvokeUnitCall(super.client, super.programId, super.owner);

  init(String name, Location location) async {
    final pda = await getPda(name);

    debugPrint("Unit init: ${pda.toBase58()}");

    final result = await send(
      method: 'init_unit',
      params: InitUnit(
        name: name,
        x: BigInt.from(location.posX),
        y: BigInt.from(location.posY),
      ),
      accounts: <AccountMeta>[
        AccountMeta.writeable(pubKey: pda, isSigner: false),
        AccountMeta.readonly(pubKey: location.id.pubKey, isSigner: false),
        AccountMeta.writeable(pubKey: owner.getId().publicKey, isSigner: true),
      ],
      signers: [
        owner.getId().keyPair!,
      ],
    );

    debugPrint("Unit init sent: $result");

    final txDetails = await super.client.rpcClient.getTransaction(result);
    debugPrint("txDetails: $txDetails");
  }

  Future<Ed25519HDPublicKey> getPda(String name) async {
    return await Ed25519HDPublicKey.findProgramAddress(
      seeds: [
        utf8.encode("unit"),
        owner.getId().publicKey.bytes,
        utf8.encode(name),
      ],
      programId: programId,
    );
  }

}
