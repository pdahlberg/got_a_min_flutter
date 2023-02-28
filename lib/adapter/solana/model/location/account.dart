import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:flutter/foundation.dart';
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
    @BFixedArray(1 * (32 * 2), BU8()) required List<int> occupied_by,
    @BU8() required int bump,
  }) = __AccountData;

  _AccountData._();

  factory _AccountData.fromBorsh(Uint8List data) {
    String str = "";
    for(int i = 0; i < data.length; i++) {
      str = "$str${data[i]},";
      if(i % 10 == 0) {
        str = "$str\n";
      }
    }
    debugPrint("fromBorsh:\n$str");
    return _$_AccountDataFromBorsh(data);
  }
}

/*
_AccountData read(BinaryReader reader) {
    debugPrint("discriminator offest: ${reader.offset}");
    var discriminator = const BFixedArray(8, BU8()).read(reader);
    debugPrint("owner offest: ${reader.offset} ");
    var owner = const BFixedArray(32, BU8()).read(reader);
    debugPrint("occupied_space offest: ${reader.offset}");
    var occupied_space = const BU64().read(reader);
    debugPrint("capacity offest: ${reader.offset}");
    var capacity = const BU64().read(reader);
    debugPrint("pos_x offest: ${reader.offset}");
    var pos_x = const BU64().read(reader);
    debugPrint("pos_y offest: ${reader.offset}");
    var pos_y = const BU64().read(reader);
    debugPrint("location_type offest: ${reader.offset}");
    var location_type = const BU8().read(reader);
    debugPrint("name offest: ${reader.offset}");
    var name = const BString().read(reader);
    debugPrint("occupied_by offest: ${reader.offset}");
    var occupied_by = const BFixedArray(10 * (32 * 2), BU8()).read(reader);
    debugPrint("bump offest: ${reader.offset}");
    var bump = const BU8().read(reader);
    debugPrint("... after offest: ${reader.offset}");

    return _AccountData(
      discriminator: discriminator,
      owner: owner,
      occupied_space: occupied_space,
      capacity: capacity,
      pos_x: pos_x,
      pos_y: pos_y,
      location_type: location_type,
      name: name,
      occupied_by: occupied_by,
      bump: bump,
    );
  }
 */