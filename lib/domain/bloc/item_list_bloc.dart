
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_events.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_state.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/mobility_type.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
import 'package:got_a_min_flutter/domain/persistence/item_repository.dart';
import 'package:got_a_min_flutter/domain/persistence/producer_repository.dart';
import 'package:got_a_min_flutter/domain/persistence/storage_repository.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {

  final TimeService _timeService;
  final ItemRepository _itemRepository;
  final SolanaServicePort _solanaServicePort;
  final StorageRepository _storageRepository;
  final ProducerRepository _producerRepository;

  ItemListBloc(this._timeService,
      this._itemRepository,
      this._solanaServicePort,
      this._storageRepository,
      this._producerRepository,) : super(const ItemListState()) {
    on<ItemListRefreshed>(_onRefresh);
    on<LocationCreated>(_onLocationCreated);
    on<LocationInitialized>(_onLocationInit);
    on<ProducerCreated>(_onProducerCreated);
    on<ProducerInitialized>(_onProducerInit);
    on<ProductionStarted>(_onProductionStarted);
    on<ResourceCreated>(_onResourceCreated);
    on<ResourceInitialized>(_onResourceInit);
    on<StorageCreated>(_onStorageCreated);
    on<StorageInitialized>(_onStorageInit);
    on<StorageRefreshed>(_onStorageRefresh);
    on<HeartbeatEnabled>(_onHeartbeatEnabled);
  }

  ItemListBloc.of(BuildContext context) : this(
    context.read(),
    context.read(),
    context.read(),
    context.read(),
    context.read(),
  );

  Future<void> _onRefresh(ItemListRefreshed event,
      Emitter<ItemListState> emit) async {
    //emit(state.copyWith(items: [])); // Not nice, but needed with fake item db
    emit(state.copyWith(items: _itemRepository.findAll()));
  }

  Future<void> _onLocationCreated(LocationCreated event,
      Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final owner = await _solanaServicePort.getOwner();
    final newItem = Location(
        await ItemId.random(),
        owner,
        false,
        nowMillis,
        event.name,
        event.position,
        100,
        0);
    final saved = _itemRepository.save(newItem);

    emit(state.copyWith(
      items: [
        ...state.items,
        saved,
      ],
    ));

    add(LocationInitialized(newItem));
  }

  Future<void> _onLocationInit(LocationInitialized event,
      Emitter<ItemListState> emit) async {
    await _solanaServicePort.initLocation(event.location);
    final dto = await _solanaServicePort.fetchLocationAccount(event.location);

    final location = event.location.copyWith(
      name: dto.name,
      position: dto.position,
      capacity: dto.capacity,
      occupiedSpace: dto.occupiedSpace,
      initialized: dto.initialized,
      timestamp: _timeService.nowMillis(),
    );

    debugPrint("locinit: ${location.initialized}, ${dto.initialized}");

    _itemRepository.save(location);

    add(ItemListRefreshed());
  }

  Future<void> _onProducerCreated(ProducerCreated event,
      Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final owner = await _solanaServicePort.getOwner();
    final newItem = Producer(
        await ItemId.random(),
        owner,
        false,
        nowMillis,
        event.resource,
        event.location,
        event.productionRate,
        event.productionTime,
        0,
    );
    final saved = _itemRepository.save(newItem);

    emit(state.copyWith(
      items: [
        ...state.items,
        saved,
      ],
    ));

    add(ProducerInitialized(newItem));
  }

  Future<void> _onProducerInit(ProducerInitialized event,
      Emitter<ItemListState> emit) async {
    await _solanaServicePort.initProducer(event.producer);
    final dto = await _solanaServicePort.fetchProducerAccount(event.producer);

    final resource = _itemRepository.findByAddress(dto.resourceId) as Resource;
    final location = _itemRepository.findByAddress(dto.locationId) as Location;

    final producer = event.producer.copyWith(
      initialized: dto.initialized,
      resource: resource,
      location: location,
      productionRate: dto.productionRate,
      productionTime: dto.productionTime,
      awaitingUnits: dto.awaitingUnits,
      timestamp: _timeService.nowMillis(),
    );

    debugPrint("resinit: ${producer.initialized}, ${dto.initialized}");

    _itemRepository.save(producer);

    add(ItemListRefreshed());
  }

  Future<void> _onProductionStarted(ProductionStarted event,
      Emitter<ItemListState> emit) async {
    await _solanaServicePort.produce(event.producer, event.storage);
    add(StorageRefreshed(event.storage));
  }

  Future<void> _onResourceCreated(ResourceCreated event,
      Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final owner = await _solanaServicePort.getOwner();
    final newItem = Resource(
        await ItemId.random(), owner, false, nowMillis, event.name);
    final saved = _itemRepository.save(newItem);

    emit(state.copyWith(
      items: [
        ...state.items,
        saved,
      ],
    ));

    add(ResourceInitialized(newItem));
  }

  Future<void> _onResourceInit(ResourceInitialized event,
      Emitter<ItemListState> emit) async {
    await _solanaServicePort.initResource(event.resource);
    final dto = await _solanaServicePort.fetchResourceAccount(event.resource);

    final resource = event.resource.copyWith(
      name: dto.name,
      initialized: dto.initialized,
      timestamp: _timeService.nowMillis(),
    );

    debugPrint("resinit: ${resource.initialized}, ${dto.initialized}");

    _itemRepository.save(resource);

    add(ItemListRefreshed());
  }

  Future<void> _onStorageCreated(StorageCreated event,
      Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final owner = await _solanaServicePort.getOwner();
    final newItem = Storage(
        await ItemId.random(),
        owner,
        false,
        nowMillis,
        event.resource,
        event.location,
        0,
        event.capacity,
        MobilityType.movable,
        1);
    final saved = _storageRepository.save(newItem);

    emit(state.copyWith(
      items: [
        ...state.items,
        saved,
      ],
    ));

    add(StorageInitialized(newItem));
  }

  Future<void> _onStorageInit(StorageInitialized event,
      Emitter<ItemListState> emit) async {
    await _solanaServicePort.initStorage(event.storage);

    add(StorageRefreshed(event.storage));
  }

  Future<void> _onStorageRefresh(StorageRefreshed event,
      Emitter<ItemListState> emit) async {
    final dto = await _solanaServicePort.fetchStorageAccount(event.storage);

    final storage = event.storage.copyWith(
      initialized: dto.initialized,
      amount: dto.amount,
      capacity: dto.capacity,
      mobilityType: dto.getMobilityType(),
      timestamp: _timeService.nowMillis(),
    );

    debugPrint("resinit: ${storage.initialized}, ${dto.initialized}");

    _storageRepository.save(storage);

    add(ItemListRefreshed());
  }

  StreamSubscription<int>? listener;

  Future<void> _onHeartbeatEnabled(HeartbeatEnabled event, Emitter<ItemListState> emit) async {
    // Ignoring the incoming event variable for now...
    if(listener != null) {
      debugPrint("Disabling heartbeat listener");
      listener?.cancel();
      listener = null;
    } else {
      debugPrint("Enabling heartbeat listener");
      listener = _timeService.heartbeat.asBroadcastStream().listen((event) {
        debugPrint("Heartbeat: $event");
        _producerRepository.findAll().forEach((producer) {
          Storage? storage = _storageRepository
              .findByLocationAndResource(producer.location, producer.resource)
              .firstOrNull;
          if (storage != null) {
            add(ProductionStarted(producer, storage));
          } else {
            debugPrint("No storage found for $producer");
          }
        });
      });
    }
  }

}
