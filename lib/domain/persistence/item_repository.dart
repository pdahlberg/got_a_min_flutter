
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';

class ItemRepository {

  final TimeService _timeService;
  final Map<ItemId, Item> db;

  ItemRepository(
    this._timeService,
  ) : db = {};

  ItemRepository.of(BuildContext context) : this(
    context.read(),
  );

  Item save(Item item) {
    /*final toSave = item.copyWith(
      timestamp: _timeService.nowMillis(),
    );*/

    return db.update(
      item.id,
      (value) => item,
      ifAbsent: () => item,
    );
  }

  Item? findById(ItemId id) {
    for (var value in db.values) {
      debugPrint(value.toString());
    }
    return db[id];
  }

  List<Item> findAll() {
    return db.values.toList();
  }

  Item? findByAddress(String address) {
    ItemId? id;
    for (var value in db.values) {
      if(value.id.publicKey.toBase58() == address) {
        id = value.id;
      }
    }

    return id == null ? null : db[id];
  }
}