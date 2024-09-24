part of 'boerenbridge_bloc.dart';

sealed class BoerenbridgeState extends Equatable {
  const BoerenbridgeState();

  List<Matties> get players;

  @override
  List<Object> get props => [players];
}

final class SelectingPlayersState extends BoerenbridgeState {
  const SelectingPlayersState(this.players);

  @override
  final List<Matties> players;
}

sealed class PlayingState extends BoerenbridgeState {
  const PlayingState(
    this.score, {
    required this.cardsInHand,
  });

  @override
  List<Matties> get players => score.keys.toList();

  final Map<Matties, int> score;
  final int cardsInHand;
}

final class ShuffleCardsState extends PlayingState {
  const ShuffleCardsState(
    super.score, {
    required super.cardsInHand,
  });

  Matties get shuffler => players.first;
}

final class EstimateTricksState extends PlayingState {
  const EstimateTricksState(
    super.score, {
    required super.cardsInHand,
    required this.estimates,
  });

  final Map<Matties, int> estimates;
}

final class InsertTricksState extends PlayingState {
  const InsertTricksState(
    super.score, {
    required super.cardsInHand,
    required this.actuals,
  });

  final Map<Matties, int> actuals;
}
