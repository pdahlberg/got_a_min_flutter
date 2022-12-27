
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/dto/location_dto.dart';
import 'package:got_a_min_flutter/domain/model/address.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

import 'accounts/location_account.dart';

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

    final payer = item.owner!;
    final location = item;

    final instructions = [
      await AnchorInstruction.forMethod(
        programId: _programId,
        method: 'init_location',
        arguments: ByteArray(
          InitLocationArguments(
            name: "name",
            position: BigInt.from(100),
            capacity: BigInt.from(100),
          ).toBorsh().toList(),
        ),
        accounts: <AccountMeta>[
          AccountMeta.writeable(pubKey: location.id.keyPair!.publicKey, isSigner: true),
          AccountMeta.writeable(pubKey: payer.keyPair.publicKey, isSigner: true),
          AccountMeta.readonly(pubKey: Ed25519HDPublicKey.fromBase58(SystemProgram.programId), isSigner: false),
        ],
        namespace: 'global',
      ),
    ];
    final message = Message(instructions: instructions);
    await _solanaClient.sendAndConfirmTransaction(
      message: message,
      signers: [
        location.id.keyPair!,
        payer.keyPair,
      ],
      commitment: Commitment.confirmed,
    );
  }

  @override
  Future<LocationDto> fetchLocationAccount(Item item) async {
    final account = await _solanaClient.rpcClient.getAccountInfo(
      item.id.publicKey.toBase58(),
      commitment: Commitment.confirmed,
      encoding: Encoding.base64,
    );

    debugPrint("Account: $account");
    var decoded = LocationAccount.fromAccountData(account!.data!);
    //debugPrint("owner: ${payer.keyPair.publicKey.toBase58()}");
    debugPrint("decoded: $decoded");

    return LocationDto(
      true,
      decoded.name,
      decoded.owner.toBase58(),
      decoded.occupied_space,
      decoded.capacity,
      decoded.position,
    );
  }



}