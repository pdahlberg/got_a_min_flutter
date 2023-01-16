
import 'package:flutter/widgets.dart';
import 'package:got_a_min_flutter/domain/bloc/result_base_state.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';

class PlayerState extends ResultBaseState {

  const PlayerState({
    required this.player_,
    String? errorMsg,
  }) : super(errorMsg);

  const PlayerState.empty() : this(player_: null);
  const PlayerState.error(String msg) : this(player_: null, errorMsg: msg);

  final Player? player_;

  Player get player => player_!;

  PlayerState copyWith({
    Player? player,
    ValueGetter<String?>? errorMsg,
  }) {
    return PlayerState(
      player_: player ?? player_,
      errorMsg: errorMsg != null ? errorMsg() : super.errorMsg,
    );
  }

  @override
  List<Object?> get props => [player_, isOk];

}

