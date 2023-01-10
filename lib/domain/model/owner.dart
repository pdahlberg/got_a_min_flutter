import 'package:got_a_min_flutter/infra/extension_methods.dart';
import 'package:solana/solana.dart';

class Owner {

  final Ed25519HDKeyPair keyPair;

  Owner(this.keyPair);

  @override
  String toString() {
    return keyPair.publicKey.toShortString();
  }

}
