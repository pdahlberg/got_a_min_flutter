
import 'package:flutter/widgets.dart';
import 'package:got_a_min_flutter/domain/bloc/result_base_state.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';

class ItemDetailsState extends ResultBaseState {

  const ItemDetailsState({
    required this.item,
    String? errorMsg,
  }) : super(errorMsg);

  const ItemDetailsState.error(String msg) : this(item: const Item.empty(), errorMsg: msg);

  final Item item;

  ItemDetailsState copyWith({
    Item? item,
    ValueGetter<String?>? errorMsg,
  }) {
    return ItemDetailsState(
      item: item ?? this.item,
      errorMsg: errorMsg != null ? errorMsg() : super.errorMsg,
    );
  }

  @override
  List<Object?> get props => [item, isOk];

}

