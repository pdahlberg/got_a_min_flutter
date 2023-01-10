
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Producer extends Item {

  final int productionRate;

  const Producer(super.id, super.owner, super.initialized, super.timestamp, this.productionRate);
  const Producer.empty() : this(const ItemId.empty(), null, false, 0, 0);

  Producer copyWith({
    ItemId? id,
    int? productionRate,
    int? timestamp,
    Owner? owner,
    bool? initialized,
  }) {
    return Producer(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      productionRate ?? this.productionRate,
    );
  }

  @override
  String label() => "Producer ${id.publicKey.toShortString()}";


  @override
  String toString() {
    return 'Producer{productionRate: $productionRate, ${super.toStringProps()}}';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    productionRate,
  ];

}