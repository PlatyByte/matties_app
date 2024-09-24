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
