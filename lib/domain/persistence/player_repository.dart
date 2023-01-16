
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/domain/service/time_service.dart';

class PlayerRepository {

  final TimeService _timeService;
  final Map<ItemId, Player> db;

  PlayerRepository(
    this._timeService,
  ) : db = {};

  PlayerRepository.of(BuildContext context) : this(
    context.read(),
  );

  Player save(Player player) {
    /*final toSave = player.copyWith(
      timestamp: _timeService.nowMillis(),
    );*/

    return db.update(
      player.id,
      (value) => player,
      ifAbsent: () => player,
    );
  }

  Player? findById(ItemId id) {
    for (var value in db.values) {
      debugPrint(value.toString());
    }
    return db[id];
  }

  List<Player> findAll() {
    final List<Player> result = [];
    result.addAll(db.values);
    return result;
  }

  Player? findByAddress(String address) {
    ItemId? id;
    for (var value in db.values) {
      if(value.id.publicKey.toBase58() == address) {
        id = value.id;
      }
    }

    return id == null ? null : db[id];
  }
}