
import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';

abstract class Item extends Equatable {

  final ItemId id;
  final Owner? owner;
  final bool initialized;
  final int timestamp;

  const Item(this.id, this.owner, this.initialized, this.timestamp);

  String label();

}

