
import 'dart:convert';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:got_a_min_flutter/adapter/solana/model/invoke_base.dart';
import 'package:got_a_min_flutter/adapter/solana/model/with_to_borsh.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

part 'instructions.g.dart';

@BorshSerializable()
class InitStuff with _$InitStuff implements WithToBorsh<InitStuff> {
  factory InitStuff({
    @BU64() required BigInt x,
  }) = _InitStuff;

  InitStuff._();

  factory InitStuff.fromBorsh(Uint8List data) => _$InitStuffFromBorsh(data);
}

class InvokeInitStuff extends InvokeBase<InitStuff> {

  InvokeInitStuff(super.client, super.programId, super.owner);

  run(int x) async {
    final pda = await Ed25519HDPublicKey.findProgramAddress(
        seeds: [
          utf8.encode("stuff"),
          owner.getId().publicKey.bytes,
          i64Bytes(x),
        ],
        programId: programId,
    );

    final result = await send(
      method: 'debug_init_stuff',
      params: InitStuff(
        x: BigInt.from(x),
      ),
      accounts: <AccountMeta>[
        AccountMeta.writeable(pubKey: pda, isSigner: false),
        AccountMeta.writeable(pubKey: owner.getId().publicKey, isSigner: true),
      ],
      signers: [
        owner.getId().keyPair!,
      ],
    );

    final txDetails = await super.client!.rpcClient.getTransaction(result);
    debugPrint("txDetails: $txDetails");
  }

}
