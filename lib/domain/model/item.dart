
import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';

class Item extends Equatable {

  final ItemId id;
  final String name;
  final int timestamp;
  final Owner? owner;
  final bool initialized;

  const Item(this.id, this.name, this.timestamp, this.owner, this.initialized);
  const Item.from(String name) : this(const ItemId.empty(), name, 0, null, false);
  const Item.empty() : this(const ItemId.empty(), "", 0, null, false);

  Item copyWith({
    ItemId? id,
    String? name,
    int? timestamp,
    Owner? owner,
    bool? initialized,
  }) {
    return Item(
      id ?? this.id,
      name ?? this.name,
      timestamp ?? this.timestamp,
      owner ?? this.owner,
      initialized ?? this.initialized,
    );
  }

  @override
  String toString() {
    return 'Item{id: $id, name: $name}';
  }

  @override
  List<Object?> get props => [id, name];
}

