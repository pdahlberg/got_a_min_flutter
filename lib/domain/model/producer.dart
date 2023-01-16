
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Producer extends Item {

  final Resource resource;
  final Location location;
  final int productionRate;
  final int productionTime;
  final int awaitingUnits;

  const Producer(super.id, super.owner, super.initialized, super.timestamp, this.resource, this.location, this.productionRate, this.productionTime, this.awaitingUnits);
  const Producer.empty() : this(const ItemId.empty(), null, false, 0, const Resource.empty(), const Location.empty(), 0, 0, 0);

  bool get readyToProduce => initialized; // Should include storage

  Producer copyWith({
    ItemId? id,
    int? timestamp,
    Player? owner,
    bool? initialized,
    Resource? resource,
    Location? location,
    int? productionRate,
    int? productionTime,
    int? awaitingUnits,
  }) {
    return Producer(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      resource ?? this.resource,
      location ?? this.location,
      productionRate ?? this.productionRate,
      productionTime ?? this.productionTime,
        awaitingUnits ?? this.awaitingUnits,
    );
  }

  @override
  String label() => "${owner?.getName()}'s ${resource.name} prod (waiting: $awaitingUnits)";

  @override
  String toString() {
    return 'Producer{productionRate: $productionRate, waiting($awaitingUnits), ${super.toStringProps()}}';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    resource,
    productionRate,
    productionTime,
    awaitingUnits,
  ];

}