
import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:solana/anchor.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

part 'instructions.g.dart';

@BorshSerializable()
class InitLocation with _$InitLocation {
  factory InitLocation({
    @BString() required String name,
    @BU64() required BigInt position,
    @BU64() required BigInt capacity,
  }) = _InitLocation;

  InitLocation._();

  factory InitLocation.fromBorsh(Uint8List data) => _$InitLocationFromBorsh(data);
}

class InvokeInitLocation {

  final SolanaClient _client;
  final Ed25519HDPublicKey _programId;
  final Owner _owner;

  InvokeInitLocation(this._client, this._programId, this._owner);

  run(Item location) async {
    final instructions = [
      await AnchorInstruction.forMethod(
        programId: _programId,
        method: 'init_location',
        arguments: ByteArray(
          InitLocation(
            name: "name",
            position: BigInt.from(100),
            capacity: BigInt.from(100),
          ).toBorsh().toList(),
        ),
        accounts: <AccountMeta>[
          AccountMeta.writeable(pubKey: location.id.keyPair!.publicKey, isSigner: true),
          AccountMeta.writeable(pubKey: _owner.keyPair.publicKey, isSigner: true),
          AccountMeta.readonly(pubKey: Ed25519HDPublicKey.fromBase58(SystemProgram.programId), isSigner: false),
        ],
        namespace: 'global',
      ),
    ];
    final message = Message(instructions: instructions);
    await _client.sendAndConfirmTransaction(
      message: message,
      signers: [
        location.id.keyPair!,
        _owner.keyPair,
      ],
      commitment: Commitment.confirmed,
    );
  }

}
