
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_events.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_state.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/persistence/item_repository.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {

  final TimeService _timeService;
  final ItemRepository _itemRepository;
  final SolanaServicePort _solanaServicePort;

  ItemListBloc(
      this._timeService,
      this._itemRepository,
      this._solanaServicePort,
  ) : super(const ItemListState()) {
    on<ItemListRefreshed>(_onRefresh);
    on<LocationCreated>(_onLocationCreated);
    on<LocationInitialized>(_onLocationInit);
  }

  ItemListBloc.of(BuildContext context) : this(
    context.read(),
    context.read(),
    context.read(),
  );
  
  Future<void> _onRefresh(ItemListRefreshed event, Emitter<ItemListState> emit) async {

    emit(state.copyWith(items: _itemRepository.findAll()));
  }

  Future<void> _onLocationCreated(LocationCreated event, Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final owner = await _solanaServicePort.getOwner();
    final newItem = Location(await ItemId.random(), owner, false, nowMillis, "Location");
    final saved = _itemRepository.save(newItem);

    emit(state.copyWith(
        items: [
          ...state.items,
          saved,
        ],
    ));
  }

  Future<void> _onLocationInit(LocationInitialized event, Emitter<ItemListState> emit) async {
    await _solanaServicePort.initLocation(event.location);
    final dto = await _solanaServicePort.fetchLocationAccount(event.location);

    final location = event.location.copyWith(
      name: dto.name,
      initialized: dto.initialized,

    );

    debugPrint("locinit: ${location.initialized}, ${dto.initialized}");

    _itemRepository.save(location);

    add(ItemListRefreshed());
  }

}
