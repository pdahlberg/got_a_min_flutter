import 'dart:typed_data';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/anchor.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

part 'test_account.g.dart';

class TestAccount implements AnchorAccount {
  const TestAccount._({
    required this.discriminator,
    required this.number,
  });

  factory TestAccount._fromBinary(List<int> bytes) {
    final accountData = _AccountData.fromBorsh(Uint8List.fromList(bytes));

    return TestAccount._(
      discriminator: accountData.discriminator,
      number: accountData.number.toInt(),
    );
  }

  factory TestAccount.fromAccountData(AccountData accountData) {
    if (accountData is BinaryAccountData) {
      return TestAccount._fromBinary(accountData.data);
    } else {
      throw const FormatException('invalid account data found');
    }
  }

  @override
  final List<int> discriminator;
  final int number;

  @override
  String toString() {
    return 'TestAccount{$number}';
  }
}

@BorshSerializable()
class _AccountData with _$_AccountData {
  factory _AccountData({
    @BFixedArray(8, BU8()) required List<int> discriminator,
    @BU64() required BigInt number,
  }) = __AccountData;

  _AccountData._();

  factory _AccountData.fromBorsh(Uint8List data) =>
      _$_AccountDataFromBorsh(data);
}

@BorshSerializable()
class TestArguments with _$TestArguments {
  factory TestArguments({
    @BU64() required BigInt number,
  }) = _TestArguments;

  TestArguments._();

  factory TestArguments.fromBorsh(Uint8List data) => _$TestArgumentsFromBorsh(data);
}

