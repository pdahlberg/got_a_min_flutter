
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/producer.dart';
import 'package:got_a_min_flutter/domain/persistence/item_repository.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';

class ProducerRepository {

  final TimeService _timeService;
  final ItemRepository _itemRepository;

  ProducerRepository(
    this._timeService,
    this._itemRepository,
  );

  ProducerRepository.of(BuildContext context) : this(
    context.read(),
    context.read(),
  );

  Producer save(Producer producer) {
    final toSave = producer.copyWith(
      timestamp: _timeService.nowMillis(),
    );

    return _itemRepository.save(toSave) as Producer;
  }

  Producer? findById(ItemId id) {
    final item = _itemRepository.findById(id);
    if(item.runtimeType == Producer) {
      return item as Producer;
    } else {
      return null;
    }
  }

  List<Producer> findAll() {
    return _itemRepository
        .findAll()
        .where((item) => item.runtimeType == Producer)
        .map((item) => item as Producer)
        .toList();
  }

  /*Producer? findByAddress(String address) {
    ProducerId? id;
    for (var value in db.values) {
      if(value.id.publicKey.toBase58() == address) {
        id = value.id;
      }
    }

    return id == null ? null : db[id];
  }*/
}