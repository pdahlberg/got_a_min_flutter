
import 'package:flutter/widgets.dart';
import 'package:got_a_min_flutter/domain/bloc/result_base_state.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';

class ItemDetailsState extends ResultBaseState {

  const ItemDetailsState({
    required this.item_,
    String? errorMsg,
  }) : super(errorMsg);

  const ItemDetailsState.error(String msg) : this(item_: null, errorMsg: msg);

  final Item? item_;

  Item get item => item_!;

  ItemDetailsState copyWith({
    Item? item,
    ValueGetter<String?>? errorMsg,
  }) {
    return ItemDetailsState(
      item_: item ?? this.item_,
      errorMsg: errorMsg != null ? errorMsg() : super.errorMsg,
    );
  }

  @override
  List<Object?> get props => [item_, isOk];

}

