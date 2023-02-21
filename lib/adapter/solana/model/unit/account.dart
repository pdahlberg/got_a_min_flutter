import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

part 'account.g.dart';

class UnitAccount implements AnchorAccount {
  const UnitAccount._({
    required this.discriminator,
    required this.owner,
    required this.atLocationId,
    required this.name,
    required this.movementSpeed,
    required this.arrivesAt,
    required this.bump,
  });

  factory UnitAccount._fromBinary(
      List<int> bytes,
      ) {
    final accountData = _AccountData.fromBorsh(Uint8List.fromList(bytes));

    return UnitAccount._(
      discriminator: accountData.discriminator,
      owner: Ed25519HDPublicKey(accountData.owner),
      atLocationId: Ed25519HDPublicKey(accountData.at_location_id),
      name: accountData.name,
      movementSpeed: accountData.movement_speed.toInt(),
      arrivesAt: accountData.arrives_at.toInt(),
      bump: accountData.bump.toInt(),
    );
  }

  factory UnitAccount.fromAccountData(AccountData accountData) {
    if (accountData is BinaryAccountData) {
      return UnitAccount._fromBinary(accountData.data);
    } else {
      throw const FormatException('invalid account data found');
    }
  }

  @override
  final List<int> discriminator;
  final Ed25519HDPublicKey owner;
  final Ed25519HDPublicKey atLocationId;
  final String name;
  final int movementSpeed;
  final int arrivesAt;
  final int bump;

}

/*
    pub owner: Pubkey,
    pub at_location_id: Pubkey,
    pub name: String,
    pub movement_speed: i64,
    pub arrives_at: i64,
    pub bump: u8,
 */
@BorshSerializable()
class _AccountData with _$_AccountData {
  factory _AccountData({
    @BFixedArray(8, BU8()) required List<int> discriminator,
    @BFixedArray(32, BU8()) required List<int> owner,
    @BFixedArray(32, BU8()) required List<int> at_location_id,
    @BString() required String name,
    @BU64() required BigInt movement_speed,
    @BU64() required BigInt arrives_at,
    @BU8() required int bump,
  }) = __AccountData;

  _AccountData._();

  factory _AccountData.fromBorsh(Uint8List data) =>
      _$_AccountDataFromBorsh(data);
}

