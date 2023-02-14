import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/has_id.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class GameMap extends Equatable implements Owner {

  final ItemId id;
  final int compressedValue;

  const GameMap(this.id, this.compressedValue);
  GameMap.empty() : this(ItemId.empty(), 0);

  @override
  ItemId getId() => id;

  @override
  String getName() => "map";

  @override
  String toString() {
    var pk = id.publicKey.toShortString();
    return "GameMap($compressedValue, $pk)";
  }

  @override
  List<Object?> get props => [id, compressedValue];

}
