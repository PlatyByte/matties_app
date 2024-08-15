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

final class PlayingState extends BoerenbridgeState {
  const PlayingState(this.players);

  @override
  final List<Matties> players;
}
