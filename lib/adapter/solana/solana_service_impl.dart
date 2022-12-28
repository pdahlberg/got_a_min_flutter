
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/adapter/solana/model/location/instructions.dart';
import 'package:got_a_min_flutter/domain/dto/location_dto.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

import 'model/location/account.dart';

class SolanaServiceImpl extends SolanaServicePort {

  static const devnetRpcUrl = 'http://127.0.0.1:8899';
  static const devnetWebsocketUrl = 'ws://127.0.0.1:8900';
  static final _programId = Ed25519HDPublicKey.fromBase58(
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
  init(Item item) async {
    await devAirdrop(item.id.publicKey);

    final location = item;

    InvokeInitLocation(_solanaClient, _programId, item.owner!).run(location);
  }

  @override
  Future<LocationDto> fetchLocationAccount(Item item) async {
    LocationAccount decoded = await _fetchAccountInfo(item.id.publicKey, LocationAccount.fromAccountData);
    return LocationDto(
      true,
      decoded.name,
      decoded.owner.toBase58(),
      decoded.occupied_space,
      decoded.capacity,
      decoded.position,
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