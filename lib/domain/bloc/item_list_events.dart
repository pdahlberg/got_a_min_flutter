
import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/game.dart';
import 'package:got_a_min_flutter/domain/model/game_map.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
import 'package:got_a_min_flutter/domain/model/unit.dart';

abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object?> get props => [];
}

class ItemListRefreshed extends ItemListEvent {}

class LocationCreated extends ItemListEvent {
  final String name;
  final int posX;
  final int posY;
  const LocationCreated(this.name, this.posX, this.posY);
}

class LocationInitialized extends ItemListEvent {
  final Location location;

  const LocationInitialized(this.location);

  @override
  List<Object?> get props => [location];
}

class GameMapCreated extends ItemListEvent {
  const GameMapCreated();

  @override
  List<Object?> get props => [];
}

class GameMapInitialized extends ItemListEvent {
  final GameMap map;

  const GameMapInitialized(this.map);

  @override
  List<Object?> get props => [map];
}

class ProducerCreated extends ItemListEvent {
  final Player player;
  final Resource resource;
  final Location location;
  final int productionRate;
  final int productionTime;
  const ProducerCreated(this.player, this.resource, this.location, this.productionRate, this.productionTime);

  @override
  List<Object?> get props => [player, resource, location, productionRate, productionTime];
}

class ResourceCreated extends ItemListEvent {
  final String name;
  const ResourceCreated(this.name);

  @override
  List<Object?> get props => [name];
}

class StorageCreated extends ItemListEvent {
  final Player player;
  final Resource resource;
  final Location location;
  final int capacity;
  const StorageCreated(this.player, this.resource, this.location, this.capacity);

  @override
  List<Object?> get props => [player, resource, location, capacity];
}

class UnitCreated extends ItemListEvent {
  final Player player;
  final Location location;
  final String name;
  const UnitCreated(this.player, this.location, this.name);
}

class UnitInitialized extends ItemListEvent {
  final Unit unit;

  const UnitInitialized(this.unit);

  @override
  List<Object?> get props => [unit];
}

class ProducerInitialized extends ItemListEvent {
  final Producer producer;

  const ProducerInitialized(this.producer);

  @override
  List<Object?> get props => [producer];
}

class ProductionStarted extends ItemListEvent {
  final Producer producer;
  final Storage storage;

  const ProductionStarted(this.producer, this.storage);

  @override
  List<Object?> get props => [producer, storage];
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

class StorageRefreshed extends ItemListEvent {
  final Storage storage;

  const StorageRefreshed(this.storage);

  @override
  List<Object?> get props => [storage];
}

class HeartbeatEnabledProducer extends ItemListEvent {
  final bool enabled;

  const HeartbeatEnabledProducer(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class HeartbeatEnabledProductionSync extends ItemListEvent {
  final bool enabled;

  const HeartbeatEnabledProductionSync(this.enabled);

  @override
  List<Object?> get props => [enabled];
}



