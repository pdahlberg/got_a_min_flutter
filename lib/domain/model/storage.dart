
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Storage extends Item {

  final int amount;

  const Storage(super.id, super.owner, super.initialized, super.timestamp, this.amount);
  const Storage.empty() : this(const ItemId.empty(), null, false, 0, 0);

  Storage copyWith({
    ItemId? id,
    int? amount,
    int? timestamp,
    Owner? owner,
    bool? initialized,
  }) {
    return Storage(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      amount ?? this.amount,
    );
  }

  @override
  String label() => "Storage ${id.publicKey.toShortString()}";


  @override
  String toString() {
    return 'Resource{amount: $amount, ${super.toStringProps()}}';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    amount,
  ];

}