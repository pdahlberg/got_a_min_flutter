
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Producer extends Item {

  final String name;

  const Producer(super.id, super.owner, super.initialized, super.timestamp, this.name);
  const Producer.empty() : this(const ItemId.empty(), null, false, 0, "");

  Producer copyWith({
    ItemId? id,
    String? name,
    int? timestamp,
    Owner? owner,
    bool? initialized,
  }) {
    return Producer(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      name ?? this.name,
    );
  }

  @override
  String label() => "$name ${id.publicKey.toShortString()}";


  @override
  String toString() {
    return 'Producer{name: $name, ${super.toStringProps()}}';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    name,
  ];

}