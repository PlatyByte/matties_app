import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:matties_app/core/model/model.dart';
import 'package:matties_app/features/boerenbridge/boerenbridge.dart';

class ScoreForm extends StatefulWidget {
  const ScoreForm({
    required this.state,
    required this.formKey,
    super.key,
  });

  final PlayingState state;
  final GlobalKey<FormBuilderState> formKey;

  bool get isEstimating => state is EstimateTricksState;

  @override
  State<ScoreForm> createState() => _ScoreFormState();
}

class _ScoreFormState extends State<ScoreForm> {
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${widget.state.shuffler.name} should shuffle '
                '${widget.state.cardsInHand} cards',
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
                itemCount: widget.state.score.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final scoreEntry =
                      widget.state.score.entries.elementAt(index);
                  return Row(
                    children: [
                      Expanded(
                        child: Text(scoreEntry.key.name),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: FormBuilderTextField(
                          name: 'estimate_${scoreEntry.key.name}',
                          enabled: widget.isEstimating,
                          initialValue: (widget.isEstimating)
                              ? null
                              : (widget.state as InsertTricksState)
                                  .estimates[scoreEntry.key]
                                  .toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: FormBuilderValidators.skipWhen(
                            (_) => !widget.isEstimating,
                            FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.maxLength(1),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: FormBuilderTextField(
                          name: 'actual_${scoreEntry.key.name}',
                          enabled: !widget.isEstimating,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: FormBuilderValidators.skipWhen(
                            (_) => widget.isEstimating,
                            FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.maxLength(1),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(scoreEntry.value.toString()),
                      ),
                    ],
                  );
                },
              ),
            ),
            FilledButton(
              onPressed: () {
                widget.formKey.currentState?.saveAndValidate();
                final filtered = Map.of(widget.formKey.currentState!.value);
                if (widget.isEstimating) {
                  filtered.removeWhere(
                    (key, value) => key.startsWith('actual'),
                  );
                } else {
                  filtered.removeWhere(
                    (key, value) => key.startsWith('estimate'),
                  );
                }
                final values = filtered.map<Matties, int>((key, value) {
                  final mattie = key.split('_')[1];
                  return MapEntry(
                    Matties.fromString(mattie),
                    int.parse(value as String),
                  );
                });
                if (widget.isEstimating) {
                  context
                      .read<BoerenbridgeBloc>()
                      .add(EstimatedTricksEvent(values));
                } else {
                  context
                      .read<BoerenbridgeBloc>()
                      .add(AchievedTricksEvent(values));
                }
              },
              child: const Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}
