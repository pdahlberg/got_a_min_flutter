
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/mobility_type.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Storage extends Item {

  final Resource resource;
  final Location location;
  final int amount;
  final int capacity;
  final MobilityType mobilityType;
  final int movementSpeed;

  const Storage(super.id, super.owner, super.initialized, super.timestamp, this.resource, this.location, this.amount, this.capacity, this.mobilityType, this.movementSpeed);
  const Storage.empty() : this(const ItemId.empty(), null, false, 0, const Resource.empty(), const Location.empty(), 0, 0, MobilityType.fixed, 0);

  Storage copyWith({
    ItemId? id,
    int? timestamp,
    Owner? owner,
    bool? initialized,
    Resource? resource,
    Location? location,
    int? amount,
    int? capacity,
    MobilityType? mobilityType,
    int? movementSpeed,
  }) {
    return Storage(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      resource ?? this.resource,
      location ?? this.location,
      amount ?? this.amount,
      capacity ?? this.capacity,
      mobilityType ?? this.mobilityType,
      movementSpeed ?? this.movementSpeed,
    );
  }

  @override
  String label() => "${resource.name} storage amount=$amount, mt=$mobilityType, spd=$movementSpeed";


  @override
  String toString() {
    return 'Resource{amount: $amount, ${super.toStringProps()}}';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    resource,
    location,
    amount,
    capacity,
    mobilityType,
    movementSpeed,
  ];

}