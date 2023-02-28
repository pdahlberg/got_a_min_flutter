
import 'dart:async';
import 'dart:convert';

import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/adapter/solana/solana_service_impl.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_events.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_state.dart';
import 'package:got_a_min_flutter/domain/model/compressed_sparse_matrix.dart';
import 'package:got_a_min_flutter/domain/model/game.dart';
import 'package:got_a_min_flutter/domain/model/game_map.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/model/location_type.dart';
import 'package:got_a_min_flutter/domain/model/matrix.dart';
import 'package:got_a_min_flutter/domain/model/mobility_type.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/model/resource.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
import 'package:got_a_min_flutter/domain/model/unit.dart';
import 'package:got_a_min_flutter/domain/persistence/item_repository.dart';
import 'package:got_a_min_flutter/domain/persistence/producer_repository.dart';
import 'package:got_a_min_flutter/domain/persistence/storage_repository.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';
import 'package:solana/solana.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {

  final TimeService _timeService;
  final ItemRepository _itemRepository;
  final SolanaServicePort _solanaServicePort;
  final StorageRepository _storageRepository;
  final ProducerRepository _producerRepository;
  StreamSubscription<int>? listenerAutoProducer;
  StreamSubscription<int>? listenerProductionSync;

  ItemListBloc(this._timeService,
      this._itemRepository,
      this._solanaServicePort,
      this._storageRepository,
      this._producerRepository,) : super(const ItemListState()) {
    on<ItemListRefreshed>(_onRefresh);
    on<GameMapCreated>(_onGameMapCreated);
    on<GameMapInitialized>(_onGameMapInit);
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
    on<UnitCreated>(_onUnitCreated);
    on<UnitInitialized>(_onUnitInit);
    on<HeartbeatEnabledProducer>(_onHeartbeatEnabledProducer);
    on<HeartbeatEnabledProductionSync>(_onHeartbeatEnabledProductionSync);
  }

  ItemListBloc.of(BuildContext context) : this(
    context.read(),
    context.read(),
    context.read(),
    context.read(),
    context.read(),
  );

  Game? _game;

  Future<Game> getGame() async {
    if (_game == null) {
      final id = await ItemId.random();
      await _solanaServicePort.devAirdrop(id);
      _game = Game(id);
    }
    return _game!;
  }

  Future<void> _onRefresh(ItemListRefreshed event,
      Emitter<ItemListState> emit) async {
    //emit(state.copyWith(items: [])); // Not nice, but needed with fake item db
    emit(state.copyWith(items: _itemRepository.findAll()));
  }

  Future<void> _onGameMapCreated(GameMapCreated event,
      Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final game = await getGame();
    final newItem = GameMap(
      await ItemId.random(),
      game,
      false,
      nowMillis,
      Matrix.empty(),
    );
    final saved = _itemRepository.save(newItem);

    emit(state.copyWith(
      items: [
        ...state.items,
        saved,
      ],
    ));

    add(GameMapInitialized(newItem));
  }

  Future<void> _onGameMapInit(GameMapInitialized event,
      Emitter<ItemListState> emit) async {
    await _solanaServicePort.initMap(event.map);
    final dto = await _solanaServicePort.fetchMapAccount(event.map);

    var csm = CompressedSparseMatrix(
        dto.width, dto.height, dto.row_ptrs, dto.columns, dto.values,
        dto.compressed_value);

    final map = event.map.copyWith(
      initialized: dto.initialized,
      timestamp: _timeService.nowMillis(),
      matrix: csm.toMatrix(),
    );

    _itemRepository.save(map);

    add(ItemListRefreshed());
  }

  Iterable<int> i64Bytes(int num) {
    final writer1 = BinaryWriter();
    const BU64().write(writer1, BigInt.from(num));
    Uint8List uint8list = writer1.toArray();
    return uint8list;
  }

  Future<void> _onLocationCreated(LocationCreated event, Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    assert(event.name.length <= 8);

    final game = await getGame();

    final pda = await Ed25519HDPublicKey.findProgramAddress(
      seeds: [
        utf8.encode("map-location"),
        game
            .getId()
            .publicKey
            .bytes,
        i64Bytes(event.posX),
        i64Bytes(event.posY),
      ],
      programId: SolanaServiceImpl.programId,
    );

    final newItem = Location(
      ItemId.ofPda(pda),
      game,
      false,
      nowMillis,
      event.name,
      event.posX,
      event.posY,
      100,
      0,
      LocationType.unexplored,
    );
    final saved = _itemRepository.save(newItem);

    emit(state.copyWith(
      items: [
        ...state.items,
        saved,
      ],
    ));

    add(LocationInitialized(newItem));
  }

  Future<void> _onLocationInit(LocationInitialized event, Emitter<ItemListState> emit) async {
    await _solanaServicePort.initLocation(event.location);
    final dto = await _solanaServicePort.fetchLocationAccount(event.location);

    final location = event.location.copyWith(
      name: dto.name,
      posX: dto.posX,
      posY: dto.posY,
      capacity: dto.capacity,
      occupiedSpace: dto.occupiedSpace,
      initialized: dto.initialized,
      timestamp: _timeService.nowMillis(),
    );

    debugPrint("locinit: ${location.initialized}, ${dto.initialized}");

    _itemRepository.save(location);

    add(ItemListRefreshed());
  }

  Future<void> _onUnitCreated(UnitCreated event,
      Emitter<ItemListState> emit) async {
    final newItem = Unit.uninitialized(
      event.player,
      event.location,
      event.name,
    );
    final saved = _itemRepository.save(newItem);

    emit(state.copyWith(
      items: [
        ...state.items,
        saved,
      ],
    ));

    add(UnitInitialized(newItem));
  }

  Future<void> _onUnitInit(UnitInitialized event, Emitter<ItemListState> emit) async {
    await _solanaServicePort.initUnit(event.unit);
    final dto = await _solanaServicePort.fetchUnitAccount(event.unit);

    final location = event.unit.copyWith(
      name: dto.name,
      initialized: dto.initialized,
      timestamp: _timeService.nowMillis(),
    );

    debugPrint("locinit: ${location.initialized}, ${dto.initialized}");

    _itemRepository.save(location);

    add(ItemListRefreshed());
  }

  Future<void> _onProducerCreated(ProducerCreated event, Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final newItem = Producer(
        await ItemId.random(),
        event.player,
        false,
        nowMillis,
        event.resource,
        event.location,
        event.productionRate,
        event.productionTime,
        0,
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

  Future<void> _onProducerInit(ProducerInitialized event, Emitter<ItemListState> emit) async {
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
      claimedAt: dto.claimedAt,
      timestamp: _timeService.nowMillis(),
    );

    _producerRepository.save(producer);

    add(ItemListRefreshed());
  }

  Future<void> _onProductionStarted(ProductionStarted event, Emitter<ItemListState> emit) async {
    await _solanaServicePort.produce(event.producer, event.storage);
    add(StorageRefreshed(event.storage));
  }

  Future<void> _onResourceCreated(ResourceCreated event, Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final owner = await getGame();
    final newItem = Resource(await ItemId.random(), owner, false, nowMillis, event.name);
    final saved = _itemRepository.save(newItem);

    emit(state.copyWith(
      items: [
        ...state.items,
        saved,
      ],
    ));

    add(ResourceInitialized(newItem));
  }

  Future<void> _onResourceInit(ResourceInitialized event, Emitter<ItemListState> emit) async {
    await _solanaServicePort.initResource(event.resource);
    final dto = await _solanaServicePort.fetchResourceAccount(event.resource);

    final resource = event.resource.copyWith(
      name: dto.name,
      initialized: dto.initialized,
      timestamp: _timeService.nowMillis(),
    );

    _itemRepository.save(resource);

    add(ItemListRefreshed());
  }

  Future<void> _onStorageCreated(StorageCreated event, Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final newItem = Storage(
        await ItemId.random(),
        event.player,
        false,
        nowMillis,
        event.resource,
        event.location,
        0,
        event.capacity,
        MobilityType.movable,
        1,
        0,
        0,
    );
    final saved = _storageRepository.save(newItem);

    emit(state.copyWith(
      items: [
        ...state.items,
        saved,
      ],
    ));

    add(StorageInitialized(newItem));
  }

  Future<void> _onStorageInit(StorageInitialized event, Emitter<ItemListState> emit) async {
    await _solanaServicePort.initStorage(event.storage);

    add(StorageRefreshed(event.storage));
  }

  Future<void> _onStorageRefresh(StorageRefreshed event, Emitter<ItemListState> emit) async {
    final dto = await _solanaServicePort.fetchStorageAccount(event.storage);

    final storage = event.storage.copyWith(
      initialized: dto.initialized,
      amount: dto.amount,
      simulatedAmount: dto.amount,
      capacity: dto.capacity,
      mobilityType: dto.getMobilityType(),
      timestamp: _timeService.nowMillis(),
    );

    _storageRepository.save(storage);

    add(ItemListRefreshed());
  }

  Future<void> _onHeartbeatEnabledProducer(HeartbeatEnabledProducer event, Emitter<ItemListState> emit) async {
    // Ignoring the incoming event variable for now...
    if(listenerAutoProducer != null) {
      debugPrint("Disabling heartbeat listener");
      listenerAutoProducer?.cancel();
      listenerAutoProducer = null;
    } else {
      debugPrint("Enabling heartbeat listener");
      listenerAutoProducer = _timeService.heartbeat.listen((event) {
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

  var steps = 0;
  Future<void> _onHeartbeatEnabledProductionSync(HeartbeatEnabledProductionSync event, Emitter<ItemListState> emit) async {
    // Ignoring the incoming event variable for now...
    if(listenerProductionSync != null) {
      debugPrint("Disabling heartbeat listener for prod sync");
      if(listenerProductionSync!.isPaused) {
        listenerProductionSync!.resume();
      } else {
        listenerProductionSync!.pause();
      }
      //listenerProductionSync = null;
    } else {
      final newInterval = await _solanaServicePort.averageSlotTime();
      _timeService.setHeartbeatInterval(millis: newInterval);
      debugPrint("Enabling heartbeat listener for prod sync");
      debugPrint("newInterval = $newInterval");
      listenerProductionSync = _timeService.heartbeat.listen((timeUnit) async {
        final time = _timeService.nowMillis();
        debugPrint("timeUnit: $timeUnit, time: $time, interval: ${_timeService.heartbeatInterval}");
        steps++;
        if(steps > 5) {
          final newInterval = await _solanaServicePort.averageSlotTime();
          _timeService.setHeartbeatInterval(millis: newInterval);
          steps = 0;
        }

        /*_storageRepository
            .findAll()
            .map((s) {
              var diff = seconds - s.simulatedAmountTimestamp;
              return s.copyWith(
                simulatedAmount: s.simulatedAmount + diff,
                simulatedAmountTimestamp: seconds,
              );
            })
            .forEach((s) {
              final saved = _storageRepository.save(s);
              add(ItemListRefreshed());
            });*/
      });
    }
  }

}
