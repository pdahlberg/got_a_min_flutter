
import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';

abstract class ItemDetailsEvent extends Equatable {
  const ItemDetailsEvent();

  @override
  List<Object?> get props => [];
}

class ItemAskedFor extends ItemDetailsEvent {
  final ItemId id;
  const ItemAskedFor(this.id);

  @override
  List<Object?> get props => [id];
}

class ItemAddressAskedFor extends ItemDetailsEvent {
  final String address;
  const ItemAddressAskedFor(this.address);

  @override
  List<Object?> get props => [address];
}

class ItemInitialized extends ItemDetailsEvent {
  final Item item;

  const ItemInitialized(this.item);

  @override
  List<Object?> get props => [item];
}
