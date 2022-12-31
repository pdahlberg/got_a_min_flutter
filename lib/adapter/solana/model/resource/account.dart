import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

part 'account.g.dart';

class ResourceAccount implements AnchorAccount {
  const ResourceAccount._({
    required this.discriminator,
    required this.owner,
    required this.name,
    required this.input,
    required this.input_amount,
  });

  factory ResourceAccount._fromBinary(
      List<int> bytes,
      ) {
    final accountData = _AccountData.fromBorsh(Uint8List.fromList(bytes));

    return ResourceAccount._(
      discriminator: accountData.discriminator,
      owner: Ed25519HDPublicKey(accountData.owner),
      name: accountData.name.toString(),
      input: [
        Ed25519HDPublicKey(accountData.input1),
        Ed25519HDPublicKey(accountData.input2)
      ],
      input_amount: [
        accountData.input_amount1.toInt(),
        accountData.input_amount2.toInt(),
      ],
    );
  }

  factory ResourceAccount.fromAccountData(AccountData accountData) {
    if (accountData is BinaryAccountData) {
      return ResourceAccount._fromBinary(accountData.data);
    } else {
      throw const FormatException('invalid account data found');
    }
  }

  @override
  final List<int> discriminator;
  final Ed25519HDPublicKey owner;
  final String name;
  final List<Ed25519HDPublicKey> input;
  final List<int> input_amount;

  @override
  String toString() {
    return 'ResourceAccount{owner: ${owner.toBase58()}, input_amount: $input_amount, input: $input, name: $name}';
  }
}

@BorshSerializable()
class _AccountData with _$_AccountData {
  factory _AccountData({
    @BFixedArray(8, BU8()) required List<int> discriminator,
    @BFixedArray(32, BU8()) required List<int> owner,
    @BString() required String name,
    @BFixedArray(32, BU8()) required List<int> input1,
    @BFixedArray(32, BU8()) required List<int> input2,
    @BU64() required BigInt input_amount1,
    @BU64() required BigInt input_amount2,
  }) = __AccountData;

  _AccountData._();

  factory _AccountData.fromBorsh(Uint8List data) =>
      _$_AccountDataFromBorsh(data);
}

