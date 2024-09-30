import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matties_app/features/boerenbridge/boerenbridge.dart';

class StartGameButton extends StatelessWidget {
  const StartGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BoerenbridgeBloc, BoerenbridgeState, bool>(
      selector: (state) => state.players.length >= 3,
      builder: (context, enoughPlayers) {
        return FilledButton(
          onPressed: !enoughPlayers
              ? null
              : () => context.read<BoerenbridgeBloc>().add(StartPlayingEvent()),
          child: const Icon(Icons.play_arrow),
        );
      },
    );
  }
}
