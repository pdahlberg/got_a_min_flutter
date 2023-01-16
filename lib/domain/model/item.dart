
import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/has_id.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';

abstract class Item extends Equatable implements HasId {

  final ItemId id;
  final Owner? owner;
  final bool initialized;
  final int timestamp;

  const Item(this.id, this.owner, this.initialized, this.timestamp);

  @override
  ItemId getId() => id;

  String label();

  @override
  String toString() {
    return 'Item{${toStringProps()}}';
  }

  String toStringProps() {
    return 'id: $id, owner: $owner, initialized: $initialized, timestamp: $timestamp';
  }

  @override
  List<Object?> get props => [id, owner, initialized, timestamp];

}

