
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/item_details_events.dart';
import 'package:got_a_min_flutter/domain/bloc/item_details_state.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/persistence/item_repository.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';

class ItemDetailsBloc extends Bloc<ItemDetailsEvent, ItemDetailsState> {

  final ItemRepository _itemRepository;
  final SolanaServicePort _solanaServicePort;

  ItemDetailsBloc(
      this._itemRepository,
      this._solanaServicePort,
  ) : super(const ItemDetailsState(item: Item.empty())) {
    on<ItemAskedFor>(_onAskedFor);
    on<ItemAddressAskedFor>(_onAddressAskedFor);
    on<ItemInitialized>(_onItemInit);
  }

  ItemDetailsBloc.of(BuildContext context) : this(
    context.read(),
    context.read(),
  );

  bool stateSyncNeeded({ ItemId? id, String? address }) {
    debugPrint("stateSyncNeeded 1 [$id, $address]");
    if(state.item.id.keyPair == null) {
      return true;
    } else if(id != null) {
      debugPrint("stateSyncNeeded 2");
      return state.item.id != id;
    } else if(address != null) {
      debugPrint("stateSyncNeeded 3");
      return state.item.id.publicKey.toBase58() != address;
    } else {
      debugPrint("stateSyncNeeded 4");
      throw UnimplementedError("ItemDetailsBloc.stateSyncNeeded called without params");
    }
  }

  Future<void> _onItemInit(ItemInitialized event, Emitter<ItemDetailsState> emit) async {
    await _solanaServicePort.init(event.item);
    final dto = await _solanaServicePort.fetchLocationAccount(event.item);

    emit(state.copyWith(
      item: dto.updateByCopy(event.item),
    ));
  }

  Future<void> _onAskedFor(ItemAskedFor event, Emitter<ItemDetailsState> emit) async {
    final item = _itemRepository.findById(event.id);

    debugPrint("AskedFor: ${event.id} => $item");

    if(item == null) {
      var errorMsg = "No item found for id: ${event.id}";
      //addError(errorMsg);
      emit(ItemDetailsState.error(errorMsg));
    } else {
      emit(ItemDetailsState(item: item));
    }
  }

  Future<void> _onAddressAskedFor(ItemAddressAskedFor event, Emitter<ItemDetailsState> emit) async {
    debugPrint("AddressAskedFor: ${event.address}");

    final item = _itemRepository.findByAddress(event.address);

    debugPrint("AddressAskedFor: ${event.address} => $item");

    if(item == null) {
      var errorMsg = "No item found for address: ${event.address}";
      //addError(errorMsg);
      emit(ItemDetailsState.error(errorMsg));
    } else {
      emit(ItemDetailsState(item: item));
    }
  }

}
