
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_events.dart';
import 'package:got_a_min_flutter/domain/bloc/item_list_state.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
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
    on<ItemAdded>(_onAdd);
  }

  ItemListBloc.of(BuildContext context) : this(
    context.read(),
    context.read(),
    context.read(),
  );
  
  Future<void> _onRefresh(ItemListRefreshed event, Emitter<ItemListState> emit) async {

    emit(state.copyWith(items: _itemRepository.findAll()));
  }

  Future<void> _onAdd(ItemAdded event, Emitter<ItemListState> emit) async {
    var nowMillis = _timeService.nowMillis();

    final owner = await _solanaServicePort.getOwner();
    final newItem = Item(await ItemId.random(), event.name, nowMillis, owner, false);
    final saved = _itemRepository.save(newItem);

    emit(state.copyWith(
        items: [
          ...state.items,
          saved,
        ],
    ));
  }

}
