
import 'package:equatable/equatable.dart';
import 'package:solana/solana.dart';

class ItemId extends Equatable {

  final Ed25519HDKeyPair? keyPair;

  const ItemId(this.keyPair);
  const ItemId.empty() : this(null);

  static Future<ItemId> random() async => ItemId(await Ed25519HDKeyPair.random());

  Ed25519HDPublicKey get publicKey {
    if(keyPair == null) {
      throw UnimplementedError("ItemId.keyPair is null");
    }
    return keyPair!.publicKey;
  }

  @override
  List<Object?> get props => [keyPair];

}