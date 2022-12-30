
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
class InitResource with _$InitResource implements WithToBorsh<InitResource> {
  factory InitResource({
    @BString() required String name,
    @BFixedArray(32, BU8()) required List<int> input1,
    @BFixedArray(32, BU8()) required List<int> input2,
    @BU64() required BigInt input_amount1,
    @BU64() required BigInt input_amount2,
  }) = _InitResource;

  InitResource._();

  factory InitResource.fromBorsh(Uint8List data) => _$InitResourceFromBorsh(data);
}

class InvokeInitResource extends InvokeBase<InitResource> {

  InvokeInitResource(super.client, super.programId, super.owner);

  run(Item resource) async {
    await send(
      method: 'init_resource',
      params: InitResource(
        name: "name",
        input1: [],
        input2: [],
        input_amount1: BigInt.from(0),
        input_amount2: BigInt.from(0),
      ),
      accounts: <AccountMeta>[
        AccountMeta.writeable(pubKey: resource.id.keyPair!.publicKey, isSigner: true),
        AccountMeta.writeable(pubKey: owner.keyPair.publicKey, isSigner: true),
      ],
      signers: [
        resource.id.keyPair!,
        owner.keyPair,
      ],
    );
  }

}
