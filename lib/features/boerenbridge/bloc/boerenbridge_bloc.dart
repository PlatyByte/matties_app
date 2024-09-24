import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:matties_app/core/model/model.dart';

part 'boerenbridge_event.dart';

part 'boerenbridge_state.dart';

class BoerenbridgeBloc extends Bloc<BoerenbridgeEvent, BoerenbridgeState> {
  BoerenbridgeBloc() : super(const SelectingPlayersState([])) {
    on<AddPlayerEvent>(_onAddPlayer);
    on<RemovePlayerEvent>(_onRemovePlayer);
    on<ReorderPlayerEvent>(_onReorderPlayer);
    on<StartPlayingEvent>(_onStartPlaying);
  }

  FutureOr<void> _onAddPlayer(
    AddPlayerEvent event,
    Emitter<BoerenbridgeState> emit,
  ) {
    final players = List.of(state.players);
    emit(
      SelectingPlayersState(players..add(event.mattie)),
    );
  }

  FutureOr<void> _onRemovePlayer(
    RemovePlayerEvent event,
    Emitter<BoerenbridgeState> emit,
  ) {
    final players = List.of(state.players);
    emit(
      SelectingPlayersState(players..remove(event.mattie)),
    );
  }

  FutureOr<void> _onReorderPlayer(
    ReorderPlayerEvent event,
    Emitter<BoerenbridgeState> emit,
  ) {
    final oldIndex = event.oldIndex;
    var newIndex = event.newIndex;
    final players = List.of(state.players);

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final player = players.removeAt(oldIndex);
    players.insert(newIndex, player);

    emit(SelectingPlayersState(players));
  }

  FutureOr<void> _onStartPlaying(
    StartPlayingEvent event,
    Emitter<BoerenbridgeState> emit,
  ) {
    emit(
      ShuffleCardsState(
        Map.fromIterable(state.players, value: (element) => 0),
        cardsInHand: 7,
      ),
    );
  }
}
