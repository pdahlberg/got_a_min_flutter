
import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';

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

class ProducerCreated extends ItemListEvent {
  final int productionRate;
  const ProducerCreated(this.productionRate);

  @override
  List<Object?> get props => [productionRate];
}

class ResourceCreated extends ItemListEvent {
  final String name;
  const ResourceCreated(this.name);

  @override
  List<Object?> get props => [name];
}

class StorageCreated extends ItemListEvent {
  final Resource resource;
  final int capacity;
  const StorageCreated(this.resource, this.capacity);

  @override
  List<Object?> get props => [resource, capacity];
}

class ProducerInitialized extends ItemListEvent {
  final Producer producer;

  const ProducerInitialized(this.producer);

  @override
  List<Object?> get props => [producer];
}

class ResourceInitialized extends ItemListEvent {
  final Resource resource;

  const ResourceInitialized(this.resource);

  @override
  List<Object?> get props => [resource];
}

class StorageInitialized extends ItemListEvent {
  final Storage storage;

  const StorageInitialized(this.storage);

  @override
  List<Object?> get props => [storage];
}

