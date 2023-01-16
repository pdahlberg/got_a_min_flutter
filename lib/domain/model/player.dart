import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/has_id.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/owner.dart';
import 'package:got_a_min_flutter/infra/extension_methods.dart';

class Player extends Equatable implements Owner {

  final ItemId id;
  final String name;

  const Player(this.id, this.name);
  const Player.empty() : this(const ItemId.empty(), "");

  @override
  ItemId getId() => id;

  @override
  String getName() => name;

  @override
  String toString() {
    var pk = id.publicKey.toShortString();
    return "Player($name, $pk)";
  }

  @override
  List<Object?> get props => [id, name];

}
