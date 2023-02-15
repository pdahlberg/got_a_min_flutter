import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/has_id.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/matrix.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class GameMap extends Equatable implements Owner {

  final ItemId id;
  final Matrix matrix;

  const GameMap(this.id, this.matrix);
  GameMap.empty() : this(ItemId.empty(), Matrix.empty());

  @override
  ItemId getId() => id;

  @override
  String getName() => "map";

  @override
  String toString() {
    var pk = id.publicKey.toShortString();
    return "GameMap($matrix)";
  }

  @override
  List<Object?> get props => [id, matrix];

}
