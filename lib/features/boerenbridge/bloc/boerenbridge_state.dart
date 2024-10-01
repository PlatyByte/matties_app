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
    required this.goingDown,
  });

  @override
  List<Matties> get players => score.keys.toList();

  Matties get shuffler => players.first;

  final Map<Matties, int> score;
  final int cardsInHand;
  final bool goingDown;

  @override
  List<Object> get props => [...super.props, score, cardsInHand, goingDown];
}

final class EstimateTricksState extends PlayingState {
  const EstimateTricksState(
    super.score, {
    required super.cardsInHand,
    required super.goingDown,
  });
}

final class InsertTricksState extends PlayingState {
  const InsertTricksState(
    super.score, {
    required super.cardsInHand,
    required super.goingDown,
    required this.estimates,
  });

  final Map<Matties, int> estimates;

  @override
  List<Object> get props => [...super.props, estimates];
}
