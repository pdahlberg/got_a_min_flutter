import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

part 'account.g.dart';

class LocationAccount implements AnchorAccount {
  const LocationAccount._({
    required this.discriminator,
    required this.owner,
    required this.occupied_space,
    required this.capacity,
    required this.name,
    required this.pos_x,
    required this.pos_y,
    required this.occupied_by,
    required this.location_type,
    required this.bump,
  });

  factory LocationAccount._fromBinary(
      List<int> bytes,
      ) {
    final accountData = _AccountData.fromBorsh(Uint8List.fromList(bytes));

    return LocationAccount._(
      discriminator: accountData.discriminator,
      owner: Ed25519HDPublicKey(accountData.owner),
      occupied_space: accountData.occupied_space.toInt(),
      capacity: accountData.capacity.toInt(),
      name: accountData.name.toString(),
      pos_x: accountData.pos_x.toInt(),
      pos_y: accountData.pos_y.toInt(),
      occupied_by: [],
      location_type: accountData.location_type.toInt(),
      bump: accountData.bump.toInt(),
    );
  }

  factory LocationAccount.fromAccountData(AccountData accountData) {
    if (accountData is BinaryAccountData) {
      return LocationAccount._fromBinary(accountData.data);
    } else {
      throw const FormatException('invalid account data found');
    }
  }

  @override
  final List<int> discriminator;
  final Ed25519HDPublicKey owner;
  final int occupied_space;
  final int capacity;
  final String name;
  final int pos_x;
  final int pos_y;
  final List<int> occupied_by;
  final int location_type;
  final int bump;


/*
*     pub pos_x: i64,
    pub pos_y: i64,
    pub occupied_by: Vec<OwnershipRef>,
    pub location_type: LocationType,
    pub bump: u8,
*/

  @override
  String toString() {
    return 'LocationAccount{owner: ${owner.toBase58()}, occupied_space: $occupied_space, capacity: $capacity, position: ${pos_x}x$pos_y, name: $name}';
  }
}

@BorshSerializable()
class _AccountData with _$_AccountData {
  factory _AccountData({
    @BFixedArray(8, BU8()) required List<int> discriminator,
    @BFixedArray(32, BU8()) required List<int> owner,
    @BU64() required BigInt occupied_space,
    @BU64() required BigInt capacity,
    @BU64() required BigInt pos_x,
    @BU64() required BigInt pos_y,
    @BU8() required int location_type,
    @BString() required String name,
    @BFixedArray(10 * (32 * 2), BU8()) required List<int> occupied_by,
    @BU8() required int bump,
  }) = __AccountData;

  _AccountData._();

  factory _AccountData.fromBorsh(Uint8List data) =>
      _$_AccountDataFromBorsh(data);
}

