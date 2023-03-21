
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/location.dart';
import 'package:got_a_min_flutter/domain/persistence/item_repository.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';

class LocationRepository {

  final TimeService _timeService;
  final ItemRepository _itemRepository;

  LocationRepository(
    this._timeService,
    this._itemRepository,
  );

  LocationRepository.of(BuildContext context) : this(
    context.read(),
    context.read(),
  );

  Location save(Location location) {
    final toSave = location.copyWith(
      timestamp: _timeService.nowMillis(),
    );

    return _itemRepository.save(toSave) as Location;
  }

  Location? findById(ItemId id) {
    final item = _itemRepository.findById(id);
    if(item.runtimeType == Location) {
      return item as Location;
    } else {
      return null;
    }
  }

  List<Location> findAll() {
    return _itemRepository
        .findAll()
        .where((item) => item.runtimeType == Location)
        .map((item) => item as Location)
        .toList();
  }

  Location? findByAddress(String address) {
    return _itemRepository
        .findAll()
        .where((item) => item.runtimeType == Location)
        .map((item) => item as Location)
        .firstWhere((location) => location.id.pubKey.toBase58() == address);
  }
}