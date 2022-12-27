import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/instructions.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:test/test.dart';

final devnetRpcUrl = Platform.environment['DEVNET_RPC_URL'] ?? 'http://127.0.0.1:8899';
final devnetWebsocketUrl = Platform.environment['DEVNET_WEBSOCKET_URL'] ?? 'ws://127.0.0.1:8900';
final _programId = Ed25519HDPublicKey.fromBase58(
  Platform.environment['PROGRAM_ID'] ?? '3113AWybUqHaSKaEmUXnUFwXu4EUp1VDpqQFCvY7oajN',
);

SolanaClient createTestSolanaClient({bool useLocal = true}) => SolanaClient(
  rpcUrl: Uri.parse(
    useLocal ? devnetRpcUrl : 'https://api.devnet.solana.com',
  ),
  websocketUrl: Uri.parse(
    useLocal ? devnetWebsocketUrl : 'wss://api.devnet.solana.com',
  ),
);

void main() {
  late final Ed25519HDKeyPair payer;
  late final Ed25519HDKeyPair location;
  final client = SolanaClient(
    rpcUrl: Uri.parse(devnetRpcUrl),
    websocketUrl: Uri.parse(devnetWebsocketUrl),
  );

  setUpAll(() async {
    payer = await Ed25519HDKeyPair.random();
    location = await Ed25519HDKeyPair.random();

    await client.requestAirdrop(
      address: payer.publicKey,
      lamports: 10 * lamportsPerSol,
      commitment: Commitment.confirmed,
    );

    await client.requestAirdrop(
      address: location.publicKey,
      lamports: 10 * lamportsPerSol,
      commitment: Commitment.confirmed,
    );
  });

  test('Init Location', () async {
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
          AccountMeta.writeable(pubKey: location.publicKey, isSigner: true),
          AccountMeta.writeable(pubKey: payer.publicKey, isSigner: true),
          AccountMeta.readonly(pubKey: Ed25519HDPublicKey.fromBase58(SystemProgram.programId), isSigner: false),
        ],
        namespace: 'global',
      ),
    ];
    final message = Message(instructions: instructions);
    await client.sendAndConfirmTransaction(
      message: message,
      signers: [
        location,
        payer,
      ],
      commitment: Commitment.confirmed,
    );

    final account = await client.rpcClient.getAccountInfo(
      location.address,
      commitment: Commitment.confirmed,
      encoding: Encoding.base64,
    );

    debugPrint("Account: $account");
    var decoded = LocationAccount.fromAccountData(account!.data!);
    debugPrint("owner: ${payer.publicKey}");
    debugPrint("decoded: $decoded");

    expect(decoded.occupied_space, 0);
    expect(decoded.capacity, 100);
    expect(decoded.position, 100);
    expect(decoded.name, 'name');
  });

}

