
import 'package:equatable/equatable.dart';

abstract class ItemListEvent extends Equatable {
  const ItemListEvent();

  @override
  List<Object?> get props => [];
}

class ItemListRefreshed extends ItemListEvent {}
class ItemAdded extends ItemListEvent {
  final String name;
  const ItemAdded(this.name);
}
