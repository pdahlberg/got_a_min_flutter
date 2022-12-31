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
    required this.position,
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
      position: accountData.position.toInt(),
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
  final int position;
  final String name;

  @override
  String toString() {
    return 'LocationAccount{owner: ${owner.toBase58()}, occupied_space: $occupied_space, capacity: $capacity, position: $position, name: $name}';
  }
}

@BorshSerializable()
class _AccountData with _$_AccountData {
  factory _AccountData({
    @BFixedArray(8, BU8()) required List<int> discriminator,
    @BFixedArray(32, BU8()) required List<int> owner,
    @BU64() required BigInt occupied_space,
    @BU64() required BigInt capacity,
    @BString() required String name,
    @BU64() required BigInt position,
  }) = __AccountData;

  _AccountData._();

  factory _AccountData.fromBorsh(Uint8List data) =>
      _$_AccountDataFromBorsh(data);
}

