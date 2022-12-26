import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:got_a_min_flutter/location_account.dart';
import 'package:got_a_min_flutter/test_account.dart';
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
          Basic1Arguments(
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

  test('Reading Stuff', () async {
    final stuff = Ed25519HDPublicKey.fromBase58("FCHm4Ef3b1aKpBPTk6XkKsQwf8Z3zUhkh6VbZuSrwDi8");
    final account = await client.rpcClient.getAccountInfo(
      stuff.toBase58(),
      commitment: Commitment.confirmed,
      encoding: Encoding.base64,
    );

    debugPrint("Account: $account");
    var decoded = TestAccount.fromAccountData(account!.data!);
    debugPrint("decoded: $decoded");

  });

  /*test('Testing Stuff', () async {
    // 8 bytes for the discriminator and 8 bytes for the data
    //const space = 16;
    //final rent = await client.rpcClient.getMinimumBalanceForRentExemption(space);

    final instructions = [
      await AnchorInstruction.forMethod(
        programId: _programId,
        method: 'stuff',
        arguments: ByteArray(
          TestArguments(
            number: BigInt.from(100),
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

    /*final account = await client.rpcClient.getAccountInfo(
      location.address,
      commitment: Commitment.confirmed,
    );

    debugPrint("Result: $account");
    */
  });*/

  /*test(
    'Call basic-1 update method',
        () async {
      // Call update
      final instructions = [
        await AnchorInstruction.forMethod(
          programId: _basic1,
          method: 'update',
          arguments: ByteArray(
            Basic1Arguments(data: BigInt.from(25)).toBorsh().toList(),
          ),
          accounts: <AccountMeta>[
            AccountMeta.writeable(pubKey: updater.publicKey, isSigner: false),
          ],
          namespace: 'global',
        ),
      ];

      final message = Message(instructions: instructions);
      await client.sendAndConfirmTransaction(
        message: message,
        signers: [payer],
        commitment: Commitment.confirmed,
      );

      final discriminator = await computeDiscriminator('account', 'MyAccount');
      final account = await client.rpcClient.getAccountInfo(
        updater.address,
        commitment: Commitment.confirmed,
      );

      expect(account, isNotNull);
      final rawData = account?.data;
      expect(rawData, isNotNull);
      // ignore: avoid-non-null-assertion, cannot be null here
      final dataAccount = Basic1DataAccount.fromAccountData(rawData!);
      expect(dataAccount.data, equals(25));
      expect(dataAccount.discriminator, equals(discriminator));
    },
    skip: true,
  );*/
}

