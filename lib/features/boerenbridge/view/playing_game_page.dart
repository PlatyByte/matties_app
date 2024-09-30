import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:matties_app/features/boerenbridge/boerenbridge.dart';

class PlayingGamePage extends StatelessWidget {
  const PlayingGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BoerenbridgeBloc, BoerenbridgeState>(
        builder: (context, state) {
          if (state is! PlayingState) {
            throw StateError('Should only build playing states');
          }

          return ScoreForm(
            state: state,
            formKey: GlobalKey<FormBuilderState>(),
          );
        },
      ),
    );
  }
}
