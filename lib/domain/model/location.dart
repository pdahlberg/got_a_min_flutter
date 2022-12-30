
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';

class Location extends Item {

  final String name;

  const Location(super.id, super.owner, super.initialized, super.timestamp, this.name);
  //const Location.from(String name) : this(const ItemId.empty(), name, 0, null, false);
  const Location.empty() : this(const ItemId.empty(), null, false, 0, "");

  Location copyWith({
    ItemId? id,
    String? name,
    int? timestamp,
    Owner? owner,
    bool? initialized,
  }) {
    return Location(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      name ?? this.name,
    );
  }

  @override
  String label() {
    var base58 = id.publicKey.toBase58();
    final first = base58.substring(0, 4);
    final last = base58.substring(base58.length - 4);
    return "$name $first...$last";
  }

  @override
  String toString() {
    return 'Location{id: $id, name: $name}';
  }

  @override
  List<Object?> get props => [id, name];

}