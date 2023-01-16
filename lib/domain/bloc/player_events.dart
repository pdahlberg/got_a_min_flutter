
import 'package:equatable/equatable.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlayerCreated extends PlayerEvent {
  const PlayerCreated();

  @override
  List<Object?> get props => [];
}

class PlayerSetActive extends PlayerEvent {
  final Player player;
  const PlayerSetActive(this.player);

  @override
  List<Object?> get props => [player];
}

class PlayerNextActivated extends PlayerEvent {
  final Player current;
  const PlayerNextActivated(this.current);

  @override
  List<Object?> get props => [current];
}
