
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
import 'package:got_a_min_flutter/domain/model/game_map.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
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
  static const devnetRpcUrl = 'http://127.0.0.1:8899';
  static const devnetWebsocketUrl = 'ws://127.0.0.1:8900';
  static final programId = Ed25519HDPublicKey.fromBase58(
    '3113AWybUqHaSKaEmUXnUFwXu4EUp1VDpqQFCvY7oajN',
  );
  final TimeService _timeService;
  final SolanaClient _solanaClient;

  static SolanaClient _createTestSolanaClient() => SolanaClient(
    rpcUrl: Uri.parse(devnetRpcUrl),
    websocketUrl: Uri.parse(devnetWebsocketUrl),
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
    await devAirdrop(unit.id);

    await InvokeUnitCall(_solanaClient, programId, unit.owner!).init(unit.name, unit.location);
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

}