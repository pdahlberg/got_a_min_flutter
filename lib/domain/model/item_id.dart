
import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';
import 'package:solana/solana.dart';

class ItemId extends Equatable {

  static final Ed25519HDPublicKey nothingPubKey = Ed25519HDPublicKey.fromBase58("11111111111111111111111111111111");
  final Ed25519HDKeyPair? keyPair;
  final Ed25519HDPublicKey pubKey;

  ItemId(Ed25519HDKeyPair? kp, Ed25519HDPublicKey? pk) :
        keyPair = kp,
        pubKey = pk ?? kp?.publicKey ?? nothingPubKey;
  ItemId.ofPda(Ed25519HDPublicKey pubKey) : this(null, pubKey);
  ItemId.empty() : this(null, nothingPubKey);

  static Future<ItemId> random() async {
    final kp = await Ed25519HDKeyPair.random();
    return ItemId(kp, kp.publicKey);
  }

  Ed25519HDPublicKey get publicKey {
    if(pubKey == nothingPubKey) {
      throw UnimplementedError("ItemId.pubKey is null");
    }
    return pubKey;
  }

  @override
  String toString() {
    return pubKey.toShortString();
  }

  @override
  List<Object?> get props => [keyPair];

}