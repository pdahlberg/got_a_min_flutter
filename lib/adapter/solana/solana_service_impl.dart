
import 'dart:convert';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/map/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/map/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/producer/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/producer/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/resource/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/resource/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/storage/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/storage/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/unit/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/unit/instructions.dart';
import 'package:got_a_min_flutter/domain/dto/game_map_dto.dart';
import 'package:got_a_min_flutter/domain/dto/location_dto.dart';
import 'package:got_a_min_flutter/domain/dto/producer_dto.dart';
import 'package:got_a_min_flutter/domain/dto/resource_dto.dart';
import 'package:got_a_min_flutter/domain/dto/storage_dto.dart';
import 'package:got_a_min_flutter/domain/dto/unit_dto.dart';
import 'package:got_a_min_flutter/domain/model/game.dart';
import 'package:got_a_min_flutter/domain/model/game_map.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/location_type.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
import 'package:got_a_min_flutter/domain/model/unit.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

import 'model/location/account.dart';

class SolanaServiceImpl extends SolanaServicePort {

  static const DEFAULT_SLOT_TIME = 400;
  //static const rpcUrl = "https://3995-94-60-19-142.eu.ngrok.io";
  //static const websocketUrl = "https://7568-94-60-19-142.eu.ngrok.io";
  static const rpcUrl = 'http://127.0.0.1:8899';
  static const websocketUrl = 'ws://127.0.0.1:8900';
  static final programId = Ed25519HDPublicKey.fromBase58(
    'CbU9TfAS58V2JprRyMZ54hM48nMseTxth6FW6sCW79nM',
  );
  final TimeService _timeService;
  final SolanaClient _solanaClient;

  static SolanaClient _createTestSolanaClient() => SolanaClient(
    rpcUrl: Uri.parse(rpcUrl),
    websocketUrl: Uri.parse(websocketUrl),
  );

  SolanaServiceImpl(
    this._timeService,
    this._solanaClient,
  );

  SolanaServiceImpl.of(BuildContext context) : this(
    context.read(),
    _createTestSolanaClient(),
  );

  @override
  Future<int> averageSlotTime() async {
    double average = 0.0;
    try {
      var samples = await _solanaClient.rpcClient.getRecentPerformanceSamples(3);
      var count = 0;
      double sum = 0.0;
      for(var sample in samples) {
        count++;
        sum += sample.samplePeriodSecs/sample.numSlots;
      }

      if(count > 0 && sum > 0) {
        average = (sum / count) * 1000;
      }

      debugPrint("Samples: ${samples.length}, count: $count, sum: $sum, avg: $average");
    } catch (e) {
      debugPrint("Error: $e");
    }
    //var block = await _solanaClient.rpcClient.getBlockHeight();
    //var time = await _solanaClient.rpcClient.getBlockTime(block);
    final result = average.toInt();
    return result == 0 ? DEFAULT_SLOT_TIME : result;
  }

  @override
  Future<void> devAirdrop(ItemId id) async {
    await _solanaClient.requestAirdrop(
      address: id.publicKey,
      lamports: 10 * lamportsPerSol,
      commitment: Commitment.confirmed,
    );
  }

  @override
  initLocation(Location location) async {
    await devAirdrop(location.id);

    await InvokeInitLocation(_solanaClient, programId, location.owner!).run(location);
    //await InvokeInitResource(_solanaClient, _programId, item.owner!).run(resource);
  }

  @override
  initProducer(Producer producer) async {
    await devAirdrop(producer.id);

    await InvokeProducerCall(_solanaClient, programId, producer.owner!).init(producer);
  }

  @override
  produce(Producer producer, Storage storage) async {
    await InvokeProducerCall(_solanaClient, programId, producer.owner!).produce(producer, storage);
    final result1 = await fetchProducerAccount(producer);
    final result2 = await fetchStorageAccount(storage);
    //debugPrint("SolanaService.produce: $result1 & $result2");
  }

  @override
  initResource(Resource resource) async {
    await devAirdrop(resource.id);

    await InvokeResourceCall(_solanaClient, programId, resource.owner!).run(resource);
    //await InvokeInitResource(_solanaClient, _programId, item.owner!).run(resource);
  }

  @override
  initStorage(Storage storage) async {
    await devAirdrop(storage.id);

    await InvokeStorageCall(_solanaClient, programId, storage.owner!).init(storage);
  }

  @override
  initMap(GameMap map) async {
    await devAirdrop(map.id);

    await InvokeMapCall(_solanaClient, programId, map.owner!).init(map);
  }

  @override
  initUnit(Unit unit) async {
    var locDto = await fetchLocationAccount(unit.location);
    debugPrint("initUnit locDto: $locDto");

    var invoke = InvokeUnitCall(_solanaClient, programId, unit.owner!);
    var unitId = unit.id;
    if(!unit.initialized) {
      unitId = ItemId.ofPda(await invoke.getPda(unit.name));
      debugPrint("initUnit airdrop to: $unitId");
      await devAirdrop(unitId);
    }

    debugPrint("initUnit id: ${unitId.publicKey.toBase58()}");
    debugPrint("initUnit location id: ${unit.location.id.publicKey.toBase58()}, is init: ${unit.location.initialized}");
    debugPrint("initUnit loc owner: ${unit.location.owner!.getId().publicKey.toBase58()}");
    await invoke.init(unit.name, unit.location);

    return unitId;
  }

  Future<ItemId> unitPda(Player player, String unitName) async {
    var invoke = InvokeUnitCall(_solanaClient, programId, player);
    return ItemId.ofPda(await invoke.getPda(unitName));
  }

  @override
  Future<LocationDto> fetchLocationAccount(Location location) async {
    final LocationAccount decoded = await _fetchAccountInfo(location.id.publicKey, LocationAccount.fromAccountData);
    return LocationDto(
      true,
      decoded.name,
      decoded.owner.toBase58(),
      decoded.occupied_space,
      decoded.capacity,
      decoded.pos_x,
      decoded.pos_y,
      decoded.location_type,
    );
  }

  @override
  Future<ProducerDto> fetchProducerAccount(Producer producer) async {
    final ProducerAccount decoded = await _fetchAccountInfo(producer.id.publicKey, ProducerAccount.fromAccountData);
    final secondsDiff = (_timeService.nowMillis() ~/ 1000) - decoded.claimedAt;
    //debugPrint("Solana block: $block, time: $time");
    //debugPrint("----====>>>> Producer: ${decoded.claimedAt} / ${_timeService.nowMillis() / 1000} / $time , awaitingUnits: ${decoded.awaitingUnits}");


    return ProducerDto(
      true,
      decoded.owner.toBase58(),
      decoded.resourceId.toBase58(),
      decoded.locationId.toBase58(),
      decoded.productionRate,
      decoded.productionTime,
      decoded.awaitingUnits,
      decoded.claimedAt,
    );
  }

  @override
  Future<ResourceDto> fetchResourceAccount(Resource resource) async {
    final ResourceAccount decoded = await _fetchAccountInfo(resource.id.publicKey, ResourceAccount.fromAccountData);
    return ResourceDto(
      true,
      decoded.name,
      decoded.owner.toBase58(),
    );
  }

  @override
  Future<StorageDto> fetchStorageAccount(Storage storage) async {
    final StorageAccount decoded = await _fetchAccountInfo(storage.id.publicKey, StorageAccount.fromAccountData);
    debugPrint("----====>>>> Storage: ${decoded.amount}");
    return StorageDto(
      true,
      decoded.owner.toBase58(),
      decoded.amount,
      decoded.capacity,
      decoded.mobilityType,
    );
  }

  @override
  Future<GameMapDto> fetchMapAccount(GameMap map) async {
    final MapAccount decoded = await _fetchAccountInfo(map.id.publicKey, MapAccount.fromAccountData);
    debugPrint("----====>>>> GameMap: ${decoded.width}x${decoded.height}");
    return GameMapDto(
      true,
      map.id,
      decoded.owner.toBase58(),
      decoded.row_ptrs,
      decoded.columns,
      decoded.values,
      decoded.width,
      decoded.height,
      decoded.compressed_value,
    );
  }

  @override
  Future<UnitDto> fetchUnitAccount(Unit unit) async {
    final UnitAccount decoded = await _fetchAccountInfo(unit.id.publicKey, UnitAccount.fromAccountData);
    debugPrint("----====>>>> Unit: ${decoded.name}");
    return UnitDto(
      true,
      decoded.owner.toBase58(),
      decoded.atLocationId.toBase58(),
      decoded.name,
      decoded.movementSpeed,
      decoded.arrivesAt,
    );
  }

  Future<T?> _fetchAccountInfo<T>(Ed25519HDPublicKey publicKey, Function(AccountData data) decode) async {
    final account = await _solanaClient.rpcClient.getAccountInfo(
      publicKey.toBase58(),
      commitment: Commitment.confirmed,
      encoding: Encoding.base64,
    );
    return decode(account!.data!);
  }

  Iterable<int> i64Bytes(int num) {
    final writer1 = BinaryWriter();
    const BU64().write(writer1, BigInt.from(num));
    Uint8List uint8list = writer1.toArray();
    return uint8list;
  }

  Future<void> test(Player p1, Location locNotWorking) async {
    var payer = await Ed25519HDKeyPair.random();
    //var p1 = Player(ItemId(payer, null), "p1");

    await devAirdrop(p1.id);

    var game = await getGame();
    final initLoc = InvokeInitLocation(_solanaClient, SolanaServiceImpl.programId, game);
    final x = 1;
    final y = 0;

    final locationPda = await Ed25519HDPublicKey.findProgramAddress(
      seeds: [
        utf8.encode("map-location"),
        game.getId().publicKey.bytes, // fails when owner is game, works with p1
        i64Bytes(x),
        i64Bytes(y),
      ],
      programId: SolanaServiceImpl.programId,
    );

    final location = Location(ItemId(null, locationPda), game, false, 0, "loc", x, y, 100, 0, LocationType.space);
    await initLoc.run(location);

    // -------------------------

    final unitInstructions = InvokeUnitCall(_solanaClient, SolanaServiceImpl.programId, p1);

    //await requestAirdrop(client, map.id.keyPair!);

    var name = "name";
    //await unitInstructions.init(name, location);

    final unitPda = await unitInstructions.getPda(name);
    debugPrint("Unit pda: ${unitPda.toBase58()}");

    var unit = Unit(ItemId.ofPda(unitPda), p1, false, 0, name, location);
    await initUnit(unit);
    var fetched = await fetchUnitAccount(unit);
    debugPrint("Unit account: $fetched");

    var gamePubKey = game.id.publicKey.toBase58();
    debugPrint("Game: $gamePubKey");
    var l1 = await fetchLocationAccount(locNotWorking);
    debugPrint("locNotWorking: $l1");
    var locationNotWorkingGamePubKey = locNotWorking.owner!.getId().publicKey.toBase58();
    debugPrint("locNotWorking owner: $locationNotWorkingGamePubKey");
    var l2 = await fetchLocationAccount(location);
    var locationGamePubKey = location.owner!.getId().publicKey.toBase58();
    debugPrint("Loc working owner: $locationGamePubKey");
    debugPrint("loc working: $l2");

  }

  Game? _game;
  Future<Game> getGame() async {
    if (_game == null) {
      final id = await ItemId.random();
      debugPrint("===> Game is null, creating new => ${id.publicKey.toBase58()}");
      await devAirdrop(id);
      _game = Game(id);
    }
    return _game!;
  }
}