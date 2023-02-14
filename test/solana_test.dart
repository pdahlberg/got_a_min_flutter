import 'dart:convert';
import 'dart:io';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/widgets.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/storage/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/storage/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/stuff/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/solana_service_impl.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/location_type.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:test/test.dart';

final devnetRpcUrl = Platform.environment['DEVNET_RPC_URL'] ?? 'http://127.0.0.1:8899';
final devnetWebsocketUrl = Platform.environment['DEVNET_WEBSOCKET_URL'] ?? 'ws://127.0.0.1:8900';

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
  late final Ed25519HDKeyPair storage;
  late final Player p1;
  final client = SolanaClient(
    rpcUrl: Uri.parse(devnetRpcUrl),
    websocketUrl: Uri.parse(devnetWebsocketUrl),
  );

  setUpAll(() async {
    payer = await Ed25519HDKeyPair.random();
    location = await Ed25519HDKeyPair.random();
    storage = await Ed25519HDKeyPair.random();
    p1 = Player(ItemId(payer, null), "p1");

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

    await client.requestAirdrop(
      address: storage.publicKey,
      lamports: 10 * lamportsPerSol,
      commitment: Commitment.confirmed,
    );
  });

<<<<<<< HEAD
  test('Init Location', () async {
    final instructions = [
      await AnchorInstruction.forMethod(
        programId: SolanaServiceImpl.programId,
        method: 'init_location',
        arguments: ByteArray(
          InitLocation(
            name: "name",
            pos_x: BigInt.from(100),
            pos_y: BigInt.from(100),
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
=======
  test('Init Stuff - PDA test', () async {
    final p1 = Player(await ItemId.random(), "p1");
    final initStuff = InvokeInitStuff(client, SolanaServiceImpl.programId, p1);
>>>>>>> pdas

    await initStuff.run(12);

    /*final account = await client.rpcClient.getAccountInfo(
      location.address,
      commitment: Commitment.confirmed,
      encoding: Encoding.base64,
    );*/

  });

  Iterable<int> i64Bytes(int num) {
    final writer1 = BinaryWriter();
    const BU64().write(writer1, BigInt.from(num));
    Uint8List uint8list = writer1.toArray();
    return uint8list;
  }

  test('Init Location', () async {

    final initLoc = InvokeInitLocation(client, SolanaServiceImpl.programId, p1);
    final x = 3;
    final y = 3;

    final pda = await Ed25519HDPublicKey.findProgramAddress(
      seeds: [
        utf8.encode("map-location"),
        p1.getId().publicKey.bytes,
        i64Bytes(x),
        i64Bytes(y),
      ],
      programId: SolanaServiceImpl.programId,
    );

    final location = Location(ItemId(null, pda), p1, false, 0, "loc", x, y, 100, 0, LocationType.unexplored);
    await initLoc.run(location);


    /*final account = await client.rpcClient.getAccountInfo(
      location.address,
      commitment: Commitment.confirmed,
      encoding: Encoding.base64,
    );*/

    /*debugPrint("Account: $account");
    var decoded = LocationAccount.fromAccountData(account!.data!);
    debugPrint("owner: ${payer.publicKey}");
    debugPrint("decoded: $decoded");

    expect(decoded.occupied_space, 0);
    expect(decoded.capacity, 100);
    expect(decoded.pos_x, 100);
    expect(decoded.pos_y, 100);
<<<<<<< HEAD
    expect(decoded.name, 'name');
=======
    expect(decoded.name, 'name');*/
>>>>>>> pdas
  });

  test('Init Storage', () async {
    final instructions = [
      await AnchorInstruction.forMethod(
        programId: SolanaServiceImpl.programId,
        method: 'init_storage',
        arguments: ByteArray(
          InitStorage(
            resource_id: location.publicKey.bytes,
            capacity: BigInt.from(100),
            mobility_type: 0,
            movement_speed: BigInt.from(0),
          ).toBorsh().toList(),
        ),
        accounts: <AccountMeta>[
          AccountMeta.writeable(pubKey: storage.publicKey, isSigner: true),
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
        storage,
        location,
        payer,
      ],
      commitment: Commitment.confirmed,
    );

    final account = await client.rpcClient.getAccountInfo(
      storage.address,
      commitment: Commitment.confirmed,
      encoding: Encoding.base64,
    );

    debugPrint("Account: $account");
    var decoded = StorageAccount.fromAccountData(account!.data!);
    debugPrint("owner: ${payer.publicKey}");
    debugPrint("decoded: $decoded");

    expect(decoded.capacity, 100);
  });

}

