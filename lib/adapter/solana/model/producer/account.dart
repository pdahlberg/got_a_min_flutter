import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

part 'account.g.dart';
class StorageAccount implements AnchorAccount {
  const StorageAccount._({
    required this.discriminator,
    required this.owner,
    required this.resourceId,
    required this.locationId,
    required this.productionRate,
    required this.productionTime,
    required this.awaitingUnits,
    required this.claimedAt,
  });

  factory StorageAccount._fromBinary(
      List<int> bytes,
      ) {
    final accountData = _AccountData.fromBorsh(Uint8List.fromList(bytes));

    return StorageAccount._(
      discriminator: accountData.discriminator,
      owner: Ed25519HDPublicKey(accountData.owner),
      resourceId: Ed25519HDPublicKey(accountData.resourceId),
      locationId: Ed25519HDPublicKey(accountData.locationId),
      productionRate: accountData.production_rate.toInt(),
      productionTime: accountData.production_time.toInt(),
      awaitingUnits: accountData.awaiting_units.toInt(),
      claimedAt: accountData.claimed_at.toInt(),
    );
  }

  factory StorageAccount.fromAccountData(AccountData accountData) {
    if (accountData is BinaryAccountData) {
      return StorageAccount._fromBinary(accountData.data);
    } else {
      throw const FormatException('invalid account data found');
    }
  }

  @override
  final List<int> discriminator;
  final Ed25519HDPublicKey owner;
  final Ed25519HDPublicKey resourceId;
  final Ed25519HDPublicKey locationId;
  final int productionRate;
  final int productionTime;
  final int awaitingUnits;
  final int claimedAt;

  @override
  String toString() {
    return 'StorageAccount{discriminator: $discriminator, owner: $owner, resourceId: $resourceId, locationId: $locationId, productionRate: $productionRate, productionTime: $productionTime, awaitingUnits: $awaitingUnits, claimedAt: $claimedAt}';
  }
}

/*
    pub owner: Pubkey,
    pub resource_id: Pubkey,
    pub location_id: Pubkey,
    pub production_rate: i64,   // Produce this many units per [production_time].
    pub production_time: i64,
    pub awaiting_units: i64,    // This amount can be claimed after waiting [production_time] * [awaiting_units] seconds.
    pub claimed_at: i64,
 */
@BorshSerializable()
class _AccountData with _$_AccountData {
  factory _AccountData({
    @BFixedArray(8, BU8()) required List<int> discriminator,
    @BFixedArray(32, BU8()) required List<int> owner,
    @BFixedArray(32, BU8()) required List<int> resourceId,
    @BFixedArray(32, BU8()) required List<int> locationId,
    @BU64() required BigInt production_rate,
    @BU64() required BigInt production_time,
    @BU64() required BigInt awaiting_units,
    @BU64() required BigInt claimed_at,
  }) = __AccountData;

  _AccountData._();

  factory _AccountData.fromBorsh(Uint8List data) =>
      _$_AccountDataFromBorsh(data);
}

