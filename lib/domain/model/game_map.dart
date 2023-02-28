import 'package:got_a_min_flutter/domain/model/item.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/matrix.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';

class GameMap extends Item implements Owner {

  final Matrix matrix;

  const GameMap(super.id, super.owner, super.initialized, super.timestamp, this.matrix);
  GameMap.empty() : this(ItemId.empty(), null, false, 0, Matrix.empty());

  GameMap copyWith({
    ItemId? id,
    Owner? owner,
    bool? initialized,
    int? timestamp,
    Matrix? matrix,
  }) {
    return GameMap(
      id ?? this.id,
      owner ?? this.owner,
      initialized ?? this.initialized,
      timestamp ?? this.timestamp,
      matrix ?? this.matrix,
    );
  }

  @override
  String getName() => "map";

  @override
  String label() {
    return matrix.toString();
  }

  @override
  String toString() {
    return "GameMap(${label()})";
  }

  @override
  List<Object?> get props => [id, matrix];

}
