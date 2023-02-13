
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location_type.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Location extends Item {

  final String name;
  final int posX;
  final int posY;
  final int capacity;
  final int occupiedSpace;
  final LocationType type;

  const Location(
    super.id,
    super.owner,
    super.initialized,
    super.timestamp,
    this.name,
    this.posX,
    this.posY,
    this.capacity,
    this.occupiedSpace,
    this.type,
  );
  //const Location.from(String name) : this(const ItemId.empty(), name, 0, null, false);
  const Location.empty() : this(const ItemId.empty(), null, false, 0, "", 0, 0, 0, 0, LocationType.unexplored);

  Location copyWith({
    ItemId? id,
    String? name,
    int? timestamp,
    Owner? owner,
    bool? initialized,
    int? posX,
    int? posY,
    int? capacity,
    int? occupiedSpace,
    LocationType? type,
  }) {
    return Location(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      name ?? this.name,
      posX ?? this.posX,
      posY ?? this.posY,
      capacity ?? this.capacity,
      occupiedSpace ?? this.occupiedSpace,
      type ?? this.type,
    );
  }

  @override
  String label() => "${owner?.getName()}'s $name @ ${posX}x$posY [$occupiedSpace/$capacity] ${id.publicKey.toShortString()}";

  @override
  String toString() {
    return 'Location{id: $id, name: $name, ${super.toStringProps()}}';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    posX,
    posY,
    capacity,
    occupiedSpace,
    type,
  ];

}