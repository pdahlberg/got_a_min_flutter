
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:solana/anchor.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

class InvokeBase {

  final SolanaClient client;
  final Ed25519HDPublicKey programId;
  final Owner owner;

  InvokeBase(this.client, this.programId, this.owner);

  Future<String> send({
    required String method,
    required List<int> params,
    required List<AccountMeta> accounts,
    required List<Ed25519HDKeyPair> signers,
  }) async {
    final instructions = [
      await AnchorInstruction.forMethod(
        programId: programId,
        method: method,
        arguments: ByteArray(params),
        accounts: accounts,
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