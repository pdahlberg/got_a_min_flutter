
import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';

abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object?> get props => [];
}

class ItemListRefreshed extends ItemListEvent {}

class LocationCreated extends ItemListEvent {
  final String name;
  final int position;
  const LocationCreated(this.name, this.position);
}

class LocationInitialized extends ItemListEvent {
  final Location location;

  const LocationInitialized(this.location);

  @override
  List<Object?> get props => [location];
}
