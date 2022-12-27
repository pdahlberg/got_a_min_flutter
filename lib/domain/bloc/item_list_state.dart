
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';

class ItemListState extends Equatable {

  const ItemListState({
    this.items = const [],
    this.selected,
    this.refreshed = 0,
  });

  final List<Item> items;
  final Item? selected;
  final int refreshed;

  ItemListState copyWith({
    List<Item>? items,
    ValueGetter<Item?>? selected,
    int? refreshed,
  }) {
    return ItemListState(
      items: items ?? this.items,
      selected: selected != null ? selected() : this.selected,
      refreshed: refreshed ?? this.refreshed,
    );
  }

  @override
  List<Object?> get props => [items, selected, refreshed];

}

