import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:matties_app/core/model/model.dart';

part 'boerenbridge_event.dart';

part 'boerenbridge_state.dart';

extension MapX on Map<dynamic, dynamic> {
  void moveFirstToLast() {
    if (!isEmpty && length > 1) {
      final firstEntry = entries.first;
      remove(firstEntry.key);
      this[firstEntry.key] = firstEntry.value;
    }
  }
}

class BoerenbridgeBloc extends Bloc<BoerenbridgeEvent, BoerenbridgeState>
    with ChangeNotifier {
  BoerenbridgeBloc({
    this.startingAmountOfCards = 7,
    this.minAmountOfPlayers = 3,
    this.maxAmountOfPlayers = 8,
  }) : super(const SelectingPlayersState([])) {
    on<AddPlayerEvent>(_onAddPlayer);
    on<RemovePlayerEvent>(_onRemovePlayer);
    on<ReorderPlayerEvent>(_onReorderPlayer);
    on<StartPlayingEvent>(_onStartPlaying);
    on<EstimatedTricksEvent>(_onEstimatedTricks);
    on<AchievedTricksEvent>(_onAchievedTricks);
    on<StopPlayingEvent>(_onStopPlaying);
  }

  final int startingAmountOfCards;
  final int minAmountOfPlayers;
  final int maxAmountOfPlayers;

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
      EstimateTricksState(
        Map.fromIterable(state.players, value: (element) => 0),
        cardsInHand: startingAmountOfCards,
        goingDown: true,
      ),
    );
    notifyListeners();
  }

  FutureOr<void> _onEstimatedTricks(
    EstimatedTricksEvent event,
    Emitter<BoerenbridgeState> emit,
  ) {
    assert(
      state is PlayingState,
      'This event should only trigger while playing',
    );
    final currentState = state as PlayingState;

    emit(
      InsertTricksState(
        currentState.score,
        cardsInHand: currentState.cardsInHand,
        estimates: event.estimates,
        goingDown: currentState.goingDown,
      ),
    );
  }

  FutureOr<void> _onAchievedTricks(
    AchievedTricksEvent event,
    Emitter<BoerenbridgeState> emit,
  ) {
    assert(
      state is InsertTricksState,
      'This event should only trigger while playing',
    );
    final currentState = state as InsertTricksState;

    final updatedScore = _calculateScores(
      currentScore: currentState.score,
      estimates: currentState.estimates,
      actuals: event.actuals,
    )..moveFirstToLast();

    final goingUp = !currentState.goingDown || currentState.cardsInHand == 1;

    final nextShuffleAmount =
        goingUp ? currentState.cardsInHand + 1 : currentState.cardsInHand - 1;

    if (goingUp && nextShuffleAmount == startingAmountOfCards + 1) {
      add(StopPlayingEvent(results: updatedScore));
    } else {
      emit(
        EstimateTricksState(
          updatedScore,
          cardsInHand: nextShuffleAmount,
          goingDown: !goingUp,
        ),
      );
    }
  }

  Map<Matties, int> _calculateScores({
    required Map<Matties, int> currentScore,
    required Map<Matties, int> estimates,
    required Map<Matties, int> actuals,
  }) {
    return currentScore.map((key, value) {
      final estimate = estimates[key]!;
      final actual = actuals[key]!;
      if (actual == estimate) {
        return MapEntry(key, value + 10 + 2 * actual);
      } else {
        return MapEntry(key, value - (2 * (actual - estimate).abs()));
      }
    });
  }

  FutureOr<void> _onStopPlaying(
    StopPlayingEvent event,
    Emitter<BoerenbridgeState> emit,
  ) {}
}
