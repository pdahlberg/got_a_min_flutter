
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Producer extends Item {

  final Resource resource;
  final Location location;
  final int productionRate;
  final int productionTime;

  const Producer(super.id, super.owner, super.initialized, super.timestamp, this.resource, this.location, this.productionRate, this.productionTime);
  const Producer.empty() : this(const ItemId.empty(), null, false, 0, const Resource.empty(), const Location.empty(), 0, 0);

  Producer copyWith({
    ItemId? id,
    int? timestamp,
    Owner? owner,
    bool? initialized,
    Resource? resource,
    Location? location,
    int? productionRate,
    int? productionTime,
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
    resource,
    productionRate,
    productionTime,
  ];

}