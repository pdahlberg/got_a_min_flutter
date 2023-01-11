
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/producer/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/producer/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/resource/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/resource/instructions.dart';
import 'package:got_a_min_flutter/adapter/solana/model/storage/account.dart';
import 'package:got_a_min_flutter/adapter/solana/model/storage/instructions.dart';
import 'package:got_a_min_flutter/domain/dto/location_dto.dart';
import 'package:got_a_min_flutter/domain/dto/producer_dto.dart';
import 'package:got_a_min_flutter/domain/dto/resource_dto.dart';
import 'package:got_a_min_flutter/domain/dto/storage_dto.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

import 'model/location/account.dart';

class SolanaServiceImpl extends SolanaServicePort {

  static const devnetRpcUrl = 'http://127.0.0.1:8899';
  static const devnetWebsocketUrl = 'ws://127.0.0.1:8900';
  static final programId = Ed25519HDPublicKey.fromBase58(
    '3113AWybUqHaSKaEmUXnUFwXu4EUp1VDpqQFCvY7oajN',
  );
  final TimeService _timeService;
  final SolanaClient _solanaClient;
  Owner? _owner;

  static SolanaClient _createTestSolanaClient() => SolanaClient(
    rpcUrl: Uri.parse(devnetRpcUrl),
    websocketUrl: Uri.parse(devnetWebsocketUrl),
  );

  SolanaServiceImpl(
    this._timeService,
    this._solanaClient,
    this._owner,
  );

  SolanaServiceImpl.of(BuildContext context) : this(
    context.read(),
    _createTestSolanaClient(),
    null,
  );

  @override
  Future<Owner> getOwner() async {
    if(_owner == null) {
      final kp = await Ed25519HDKeyPair.random();
      _owner = Owner(kp);

      await devAirdrop(_owner!.keyPair.publicKey);
    }
    return Future.value(_owner);
  }

  Future<void> devAirdrop(Ed25519HDPublicKey publicKey) async {
    await _solanaClient.requestAirdrop(
      address: publicKey,
      lamports: 10 * lamportsPerSol,
      commitment: Commitment.confirmed,
    );
  }

  @override
  initLocation(Location location) async {
    await devAirdrop(location.id.publicKey);

    await InvokeInitLocation(_solanaClient, programId, location.owner!).run(location);
    //await InvokeInitResource(_solanaClient, _programId, item.owner!).run(resource);
  }

  @override
  initProducer(Producer producer) async {
    await devAirdrop(producer.id.publicKey);

    await InvokeProducerCall(_solanaClient, programId, producer.owner!).init(producer);
  }

  @override
  initResource(Resource resource) async {
    await devAirdrop(resource.id.publicKey);

    await InvokeResourceCall(_solanaClient, programId, resource.owner!).run(resource);
    //await InvokeInitResource(_solanaClient, _programId, item.owner!).run(resource);
  }

  @override
  initStorage(Storage storage) async {
    await devAirdrop(storage.id.publicKey);

    await InvokeStorageCall(_solanaClient, programId, storage.owner!).init(storage);
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
      decoded.position,
    );
  }

  @override
  Future<ProducerDto> fetchProducerAccount(Producer producer) async {
    final ProducerAccount decoded = await _fetchAccountInfo(producer.id.publicKey, ProducerAccount.fromAccountData);
    return ProducerDto(
      true,
      decoded.owner.toBase58(),
      decoded.resourceId.toBase58(),
      decoded.locationId.toBase58(),
      decoded.productionRate,
      decoded.productionTime,
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
    return StorageDto(
      true,
      decoded.owner.toBase58(),
      decoded.amount,
      decoded.capacity,
      decoded.mobilityType,
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