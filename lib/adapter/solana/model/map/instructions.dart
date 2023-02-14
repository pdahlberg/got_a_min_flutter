
import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:got_a_min_flutter/adapter/solana/model/invoke_base.dart';
import 'package:got_a_min_flutter/adapter/solana/model/with_to_borsh.dart';
import 'package:got_a_min_flutter/domain/model/game_map.dart';
import 'package:solana/encoder.dart';

part 'instructions.g.dart';

@BorshSerializable()
class InitMap with _$InitMap implements WithToBorsh<InitMap> {
  factory InitMap({
    @BU8() required int compressed_value,
  }) = _InitMap;

  InitMap._();

  factory InitMap.fromBorsh(Uint8List data) => _$InitMapFromBorsh(data);
}

class InvokeMapCall extends InvokeBase<InitMap> {

  InvokeMapCall(super.client, super.programId, super.owner);

  // init
  init(GameMap map) async {
    await send(
      method: 'init_map',
      params: InitMap(
        compressed_value: 0,
      ),
      accounts: <AccountMeta>[
        AccountMeta.writeable(pubKey: map.id.keyPair!.publicKey, isSigner: true),
        AccountMeta.writeable(pubKey: owner.getId().publicKey, isSigner: true),
      ],
      signers: [
        map.id.keyPair!,
        owner.getId().keyPair!,
      ],
    );
  }

}
