import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/has_id.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Game extends Equatable implements Owner {

  final ItemId id;

  const Game(this.id);
  const Game.empty() : this(const ItemId.empty());

  @override
  ItemId getId() => id;

  @override
  String getName() => "Game";

  @override
  String toString() {
    var pk = id.publicKey.toShortString();
    return "Game($pk)";
  }

  @override
  List<Object?> get props => [id];

}
