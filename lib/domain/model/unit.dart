
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';

class Unit extends Item {

  final String name;
  final Location location;

  const Unit(
    super.id,
    super.owner,
    super.initialized,
    super.timestamp,
    this.name,
    this.location,
  );
  //const Unit.from(String name) : this(const ItemId.empty(), name, 0, null, false);
  const Unit.uninitialized(ItemId id, Player player, Location location, String name) : this(id, player, false, 0, name, location);
  Unit.empty() : this(ItemId.empty(), null, false, 0, "", Location.empty());

  Unit copyWith({
    ItemId? id,
    String? name,
    int? timestamp,
    Owner? owner,
    bool? initialized,
    Location? location,
  }) {
    return Unit(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      name ?? this.name,
      location ?? this.location,
    );
  }

  @override
  String label() => "${owner?.getName()}'s $name @ ${location.posX}x${location.posY} $id";

  @override
  String toString() {
    return 'Unit{id: $id, name: $name, ${super.toStringProps()}}';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    location,
  ];

}