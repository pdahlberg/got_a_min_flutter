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
    required this.amount,
    required this.capacity,
    required this.mobilityType,
    required this.movementSpeed,
    required this.arrivesAt,
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
      amount: accountData.amount.toInt(),
      capacity: accountData.capacity.toInt(),
      mobilityType: accountData.mobility_type.toInt(),
      movementSpeed: accountData.movement_speed.toInt(),
      arrivesAt: accountData.arrives_at.toInt(),
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
  final int amount;
  final int capacity;
  final int mobilityType;
  final int movementSpeed;
  final int arrivesAt;

  @override
  String toString() {
    return 'StorageAccount{discriminator: $discriminator, owner: $owner, resourceId: $resourceId, locationId: $locationId, amount: $amount, capacity: $capacity, mobilityType: $mobilityType, movementSpeed: $movementSpeed, arrivesAt: $arrivesAt}';
  }
}

/*
    pub owner: Pubkey,
    pub resource_id: Pubkey,
    pub location_id: Pubkey,
    pub amount: i64,
    pub capacity: i64,
    pub mobility_type: MobilityType,
    pub movement_speed: i64,
    pub arrives_at: i64,
 */
@BorshSerializable()
class _AccountData with _$_AccountData {
  factory _AccountData({
    @BFixedArray(8, BU8()) required List<int> discriminator,
    @BFixedArray(32, BU8()) required List<int> owner,
    @BFixedArray(32, BU8()) required List<int> resourceId,
    @BFixedArray(32, BU8()) required List<int> locationId,
    @BU64() required BigInt amount,
    @BU64() required BigInt capacity,
    @BU8() required int mobility_type,
    @BU64() required BigInt movement_speed,
    @BU64() required BigInt arrives_at,
  }) = __AccountData;

  _AccountData._();

  factory _AccountData.fromBorsh(Uint8List data) =>
      _$_AccountDataFromBorsh(data);
}

