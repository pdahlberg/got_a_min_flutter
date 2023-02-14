
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Resource extends Item {

  final String name;

  const Resource(super.id, super.owner, super.initialized, super.timestamp, this.name);
  Resource.empty() : this(ItemId.empty(), null, false, 0, "");

  Resource copyWith({
    ItemId? id,
    String? name,
    int? timestamp,
    Owner? owner,
    bool? initialized,
  }) {
    return Resource(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      name ?? this.name,
    );
  }

  @override
  String label() => "${owner?.getName()}'s $name ${id.publicKey.toShortString()}";


  @override
  String toString() {
    return 'Resource{name: $name, ${super.toStringProps()}}';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    name,
  ];

}