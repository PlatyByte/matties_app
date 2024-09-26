import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:matties_app/features/boerenbridge/boerenbridge.dart';

class PlayingGamePage extends StatefulWidget {
  const PlayingGamePage({super.key});

  @override
  State<PlayingGamePage> createState() => _PlayingGamePageState();
}

class _PlayingGamePageState extends State<PlayingGamePage> {
  late final GlobalKey<FormBuilderState> key;

  @override
  void initState() {
    super.initState();
    key = GlobalKey<FormBuilderState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BoerenbridgeBloc, BoerenbridgeState>(
        builder: (context, state) {
          if (state is! PlayingState) {
            throw StateError('Should only build playing states');
          }

          return FormBuilder(
            key: key,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${state.shuffler.name} should shuffle '
                      '${state.cardsInHand} cards',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('Player'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Text('Estimate'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Text('Actual'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text('Score'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.score.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final scoreEntry = state.score.entries.elementAt(index);
                        return Row(
                          children: [
                            Text(scoreEntry.key.name),
                            const SizedBox(width: 8),
                            FormBuilderTextField(
                              name: '${scoreEntry.key}_estimate',
                              enabled: state is EstimateTricksState,
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.skipWhen(
                                (_) => state is! EstimateTricksState,
                                FormBuilderValidators.required(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            FormBuilderTextField(
                              name: '${scoreEntry.key}_actual',
                              enabled: state is InsertTricksState,
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.skipWhen(
                                (_) => state is! InsertTricksState,
                                FormBuilderValidators.required(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(scoreEntry.value.toString()),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
