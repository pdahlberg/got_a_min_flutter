
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/mobility_type.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Storage extends Item {

  final Resource resource;
  final Location location;
  final int amount;
  final int capacity;
  final MobilityType mobilityType;
  final int movementSpeed;
  final int simulatedAmount;
  final int simulatedAmountTimestamp;

  bool get fullCapacity => amount == capacity;

  const Storage(super.id, super.owner, super.initialized, super.timestamp, this.resource, this.location, this.amount, this.capacity, this.mobilityType, this.movementSpeed, this.simulatedAmount, this.simulatedAmountTimestamp);
  Storage.empty() : this(ItemId.empty(), null, false, 0, Resource.empty(), Location.empty(), 0, 0, MobilityType.fixed, 0, 0, 0);

  Storage copyWith({
    ItemId? id,
    int? timestamp,
    Player? owner,
    bool? initialized,
    Resource? resource,
    Location? location,
    int? amount,
    int? capacity,
    MobilityType? mobilityType,
    int? movementSpeed,
    int? simulatedAmount,
    int? simulatedAmountTimestamp,
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
      simulatedAmount ?? this.simulatedAmount,
      simulatedAmountTimestamp ?? this.simulatedAmountTimestamp,
    );
  }

  @override
  String label() => "${owner?.getName()}'s ${resource.name} storage amount=$amount/$simulatedAmount ${fullCapacity ? '[FULL]' : ''}, mt=$mobilityType, spd=$movementSpeed";

  @override
  String toString() {
    return 'Storage{amount: $amount, ${super.toStringProps()}}';
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
    simulatedAmount,
    simulatedAmountTimestamp,
  ];

}