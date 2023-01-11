
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/storage.dart';
import 'package:got_a_min_flutter/domain/persistence/item_repository.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';

class StorageRepository {

  final TimeService _timeService;
  final ItemRepository _itemRepository;

  StorageRepository(
    this._timeService,
    this._itemRepository,
  );

  StorageRepository.of(BuildContext context) : this(
    context.read(),
    context.read(),
  );

  Storage save(Storage storage) {
    final toSave = storage.copyWith(
      timestamp: _timeService.nowMillis(),
    );

    return _itemRepository.save(toSave) as Storage;
  }

  Storage? findById(ItemId id) {
    final item = _itemRepository.findById(id);
    if(item.runtimeType == Storage) {
      return item as Storage;
    } else {
      return null;
    }
  }

  /*List<Storage> findAll() {
    final List<Storage> result = [];
    result.addAll(db.values);
    return result;
  }*/

  /*Storage? findByAddress(String address) {
    StorageId? id;
    for (var value in db.values) {
      if(value.id.publicKey.toBase58() == address) {
        id = value.id;
      }
    }

    return id == null ? null : db[id];
  }*/
}