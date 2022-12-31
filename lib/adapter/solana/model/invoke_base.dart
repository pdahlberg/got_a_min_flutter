
import 'package:got_a_min_flutter/adapter/solana/model/with_to_borsh.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/instructions.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:solana/anchor.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

class InvokeBase<T> {

  final SolanaClient client;
  final Ed25519HDPublicKey programId;
  final Owner owner;

  InvokeBase(this.client, this.programId, this.owner);

  Future<String> send({
    required String method,
    required WithToBorsh<T> params,
    required List<AccountMeta> accounts,
    required List<Ed25519HDKeyPair> signers,
  }) async {
    final instructions = [
      await AnchorInstruction.forMethod(
        programId: programId,
        method: method,
        arguments: ByteArray(params.toBorsh().toList()),
        accounts: [
          ...accounts,
          AccountMeta.readonly(pubKey: Ed25519HDPublicKey.fromBase58(SystemProgram.programId), isSigner: false),
        ],
        namespace: 'global',
      ),
    ];

    final message = Message(instructions: instructions);
    return await client.sendAndConfirmTransaction(
      message: message,
      signers: signers,
      commitment: Commitment.confirmed,
    );
  }

}