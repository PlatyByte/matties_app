import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matties_app/core/model/model.dart';
import 'package:matties_app/features/boerenbridge/boerenbridge.dart';

void main() {
  blocTest<BoerenbridgeBloc, BoerenbridgeState>(
    'Should go properly up and down',
    seed: () => const SelectingPlayersState(Matties.values),
    build: () => BoerenbridgeBloc(startingAmountOfCards: 3),
    act: (bloc) {
      bloc.add(StartPlayingEvent());
      for (final _ in [0, 1, 2, 3, 4, 5]) {
        bloc
          ..add(EstimatedTricksEvent(scoreCard(0)))
          ..add(AchievedTricksEvent(scoreCard(0)));
      }
    },
    expect: () => [
      isAPlayingState(cardsInHand: 3, goingDown: true),
      isAPlayingState(cardsInHand: 3, goingDown: true),
      isAPlayingState(cardsInHand: 2, goingDown: true),
      isAPlayingState(cardsInHand: 2, goingDown: true),
      isAPlayingState(cardsInHand: 1, goingDown: true),
      isAPlayingState(cardsInHand: 1, goingDown: true),
      isAPlayingState(cardsInHand: 2, goingDown: false),
      isAPlayingState(cardsInHand: 2, goingDown: false),
      isAPlayingState(cardsInHand: 3, goingDown: false),
      isAPlayingState(cardsInHand: 3, goingDown: false),
    ],
  );
}

TypeMatcher<PlayingState> isAPlayingState({
  required int cardsInHand,
  required bool goingDown,
}) =>
    isA<PlayingState>()
        .having((s) => s.cardsInHand, 'cardsInHand', cardsInHand)
        .having((s) => s.goingDown, 'goingDown', goingDown);

Map<Matties, int> scoreCard(int value) =>
    {for (final e in Matties.values) e: value};
