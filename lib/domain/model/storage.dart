
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Storage extends Item {

  final int amount;
  final int capacity;

  const Storage(super.id, super.owner, super.initialized, super.timestamp, this.amount, this.capacity);
  const Storage.empty() : this(const ItemId.empty(), null, false, 0, 0, 0);

  Storage copyWith({
    ItemId? id,
    int? timestamp,
    Owner? owner,
    bool? initialized,
    int? amount,
    int? capacity,
  }) {
    return Storage(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      amount ?? this.amount,
      capacity ?? this.capacity,
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
    capacity,
  ];

}