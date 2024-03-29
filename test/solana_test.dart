import 'dart:convert';
import 'dart:io';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/widgets.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/map/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/storage/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/storage/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/stuff/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/unit/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/unit/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/solana_service_impl.dart';
import 'package:got_a_min_flutter/domain/model/compressed_sparse_matrix.dart';
import 'package:got_a_min_flutter/domain/model/game_map.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/location_type.dart';
import 'package:got_a_min_flutter/domain/model/matrix.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';
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

Iterable<int> i64Bytes(int num) {
  final writer1 = BinaryWriter();
  const BU64().write(writer1, BigInt.from(num));
  Uint8List uint8list = writer1.toArray();
  return uint8list;
}

void main() {
  late final Ed25519HDKeyPair payer;
  late final Ed25519HDKeyPair location;
  late final Ed25519HDKeyPair storage;
  late final Player p1;
  final client = SolanaClient(
    rpcUrl: Uri.parse(devnetRpcUrl),
    websocketUrl: Uri.parse(devnetWebsocketUrl),
  );
  final SolanaServicePort solanaService = SolanaServiceImpl(TimeService(), client);

  setUpAll(() async {
    payer = await Ed25519HDKeyPair.random();
    location = await Ed25519HDKeyPair.random();
    storage = await Ed25519HDKeyPair.random();
    p1 = Player(ItemId(payer, null), "p1");

    await requestAirdrop(client, payer);
    await requestAirdrop(client, location);
    await requestAirdrop(client, storage);
  });

  test('Init Stuff - PDA test', () async {
    final p1 = Player(await ItemId.random(), "p1");
    final initStuff = InvokeInitStuff(client, SolanaServiceImpl.programId, p1);

    await initStuff.run(12);

    /*final account = await client.rpcClient.getAccountInfo(
      location.address,
      commitment: Commitment.confirmed,
      encoding: Encoding.base64,
    );*/

  });

  test('Init Map', () async {
    final mapInstr = InvokeMapCall(client, SolanaServiceImpl.programId, p1);

    GameMap map = GameMap.empty(); // todo: should not be empty
    await requestAirdrop(client, map.id.keyPair!);

    await mapInstr.init(map);

    final dto = await solanaService.fetchMapAccount(map);

    debugPrint("map dto: $dto");
  });

  Future<UnitAccount> fetchAccount(String pubKey) async {
    final publicKey = Ed25519HDPublicKey.fromBase58(pubKey);
    final account = await client.rpcClient.getAccountInfo(
      publicKey.toBase58(),
      commitment: Commitment.confirmed,
      encoding: Encoding.base64,
    );
    return UnitAccount.fromAccountData(account!.data!);
  }

  test('Unit account', () async {
    debugPrint("Things that differ:");
    debugPrint("- owner");
    debugPrint("- location");

    var abc = await fetchAccount("FAsxWgNxanhKFubyr6JDhk9GcpxARkwGjUsqbmJfVAZM");
    debugPrint("abc: ${abc.name}");
  });

  test('Init Unit', () async {
    // -------------------------
    final game = await solanaService.getGame();
    final initLoc = InvokeInitLocation(client, SolanaServiceImpl.programId, game);
    final x = 1;
    final y = 0;

    final locationPda = await Ed25519HDPublicKey.findProgramAddress(
      seeds: [
        utf8.encode("map-location"),
        game.getId().publicKey.bytes,
        i64Bytes(x),
        i64Bytes(y),
      ],
      programId: SolanaServiceImpl.programId,
    );

    final location = Location(ItemId(null, locationPda), game, false, 0, "loc", x, y, 100, 0, LocationType.space);
    await initLoc.run(location);
    final locationDto = await solanaService.fetchLocationAccount(location);

    // -------------------------

    final unitInstructions = InvokeUnitCall(client, SolanaServiceImpl.programId, p1);

    //await requestAirdrop(client, map.id.keyPair!);

    await unitInstructions.init("name", location);

    final unitPda = await unitInstructions.getPda("name");
    debugPrint("Unit pda: ${unitPda.toBase58()}");

    //final dto = await solanaService.fetchMapAccount(map);

    //debugPrint("map dto: $dto");
  });

  test('Init Location', () async {

    final initLoc = InvokeInitLocation(client, SolanaServiceImpl.programId, p1);
    final x = 15;
    final y = x;

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

    final abc = await solanaService.fetchLocationAccount(location);
    debugPrint("l: ${abc.posX}");
    debugPrint("l: ${abc.locationType} / ${abc.getLocationType()}");
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

Future<void> requestAirdrop(SolanaClient client, Ed25519HDKeyPair storage) async {
  await client.requestAirdrop(
    address: storage.publicKey,
    lamports: 10 * lamportsPerSol,
    commitment: Commitment.confirmed,
  );
}

