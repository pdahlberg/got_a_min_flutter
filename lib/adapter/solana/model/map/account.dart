import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

part 'account.g.dart';

class MapAccount implements AnchorAccount {
  const MapAccount._({
    required this.discriminator,
    required this.owner,
    required this.row_ptrs,
    required this.columns,
    required this.values,
    required this.width,
    required this.height,
    required this.compressed_value,
  });

  factory MapAccount._fromBinary(
      List<int> bytes,
      ) {
    final accountData = _AccountData.fromBorsh(Uint8List.fromList(bytes));

    return MapAccount._(
      discriminator: accountData.discriminator,
      owner: Ed25519HDPublicKey(accountData.owner),
      row_ptrs: accountData.row_ptrs,
      columns: accountData.columns,
      values: accountData.values,
      width: accountData.width,
      height: accountData.height,
      compressed_value: accountData.compressed_value,
    );
  }

  factory MapAccount.fromAccountData(AccountData accountData) {
    if (accountData is BinaryAccountData) {
      return MapAccount._fromBinary(accountData.data);
    } else {
      throw const FormatException('invalid account data found');
    }
  }

  @override
  final List<int> discriminator;
  final Ed25519HDPublicKey owner;
  final List<int> row_ptrs;
  final List<int> columns;
  final List<int> values;
  final int width;
  final int height;
  final int compressed_value;

  @override
  String toString() {
    return 'MapAccount{discriminator: $discriminator, owner: $owner, row_ptrs: $row_ptrs, columns: $columns, values: $values, width: $width, height: $height, compressed_value: $compressed_value}';
  }

}

@BorshSerializable()
class _AccountData with _$_AccountData {
  factory _AccountData({
    @BFixedArray(8, BU8()) required List<int> discriminator,
    @BFixedArray(32, BU8()) required List<int> owner,
    @BFixedArray(10, BU8()) required List<int> row_ptrs,
    @BFixedArray(20, BU8()) required List<int> columns,
    @BFixedArray(20, BU8()) required List<int> values,
    @BU8() required int width,
    @BU8() required int height,
    @BU8() required int compressed_value,
  }) = __AccountData;

  _AccountData._();

  factory _AccountData.fromBorsh(Uint8List data) =>
      _$_AccountDataFromBorsh(data);
}

