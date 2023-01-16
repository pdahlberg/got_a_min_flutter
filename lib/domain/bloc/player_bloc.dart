
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:got_a_min_flutter/domain/bloc/player_events.dart';
import 'package:got_a_min_flutter/domain/bloc/player_state.dart';
import 'package:got_a_min_flutter/domain/model/item_id.dart';
import 'package:got_a_min_flutter/domain/model/player.dart';
import 'package:got_a_min_flutter/domain/persistence/player_repository.dart';
import 'package:collection/collection.dart';
import 'package:got_a_min_flutter/domain/service/solana_service_port.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {

  final PlayerRepository _playerRepository;
  final SolanaServicePort _solanaService;
  final random = Random();

  PlayerBloc(
      this._playerRepository,
      this._solanaService,
  ) : super(const PlayerState.empty()) {
    on<PlayerCreated>(_onPlayerCreated);
    on<PlayerSetActive>(_onPlayerSetActive);
    on<PlayerNextActivated>(_onPlayerNextActivated);
  }

  PlayerBloc.of(BuildContext context) : this(
    context.read(),
    context.read(),
  );

  Future<void> _onPlayerCreated(PlayerCreated event, Emitter<PlayerState> emit) async {
    final id = await ItemId.random();
    await _solanaService.devAirdrop(id);
    final num = _playerRepository.findAll().length + 1;
    final name = "P$num";
    final player = Player(id, name);
    final created = _playerRepository.save(player);
    add(PlayerSetActive(created));
  }

  Future<void> _onPlayerSetActive(PlayerSetActive event, Emitter<PlayerState> emit) async {
    emit(state.copyWith(player: event.player));
  }

  Future<void> _onPlayerNextActivated(PlayerNextActivated event, Emitter<PlayerState> emit) async {
    final players = _playerRepository.findAll();
    if(players.length > 1) {
      Player selected;
      final index = players.indexOf(event.current) + 1;
      if(index < players.length) {
        selected = players[index];
      } else {
        selected = players[0];
      }

      add(PlayerSetActive(selected));
    }
  }

}
