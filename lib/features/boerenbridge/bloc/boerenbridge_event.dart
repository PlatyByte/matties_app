part of 'boerenbridge_bloc.dart';

sealed class BoerenbridgeEvent extends Equatable {
  const BoerenbridgeEvent();
}

final class AddPlayerEvent extends BoerenbridgeEvent {
  const AddPlayerEvent(this.mattie);

  final Matties mattie;

  @override
  List<Object?> get props => [mattie];
}

final class RemovePlayerEvent extends BoerenbridgeEvent {
  const RemovePlayerEvent(this.mattie);

  final Matties mattie;

  @override
  List<Object?> get props => [mattie];
}

final class ReorderPlayerEvent extends BoerenbridgeEvent {
  const ReorderPlayerEvent({
    required this.oldIndex,
    required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [
        oldIndex,
        newIndex,
        // Makes the event unique in order to allow multiple triggers
        DateTime.now(),
      ];
}

final class StartPlayingEvent extends BoerenbridgeEvent {
  @override
  List<Object?> get props => [];
}

final class StopPlayingEvent extends BoerenbridgeEvent {
  const StopPlayingEvent({this.results});

  final Map<Matties, int>? results;

  @override
  List<Object?> get props => [results];
}

final class EstimatedTricksEvent extends BoerenbridgeEvent {
  const EstimatedTricksEvent(this.estimates);

  final Map<Matties, int> estimates;

  @override
  List<Object?> get props => [estimates];
}

final class AchievedTricksEvent extends BoerenbridgeEvent {
  const AchievedTricksEvent(this.actuals);

  final Map<Matties, int> actuals;

  @override
  List<Object?> get props => [actuals];
}
