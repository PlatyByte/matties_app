import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matties_app/core/model/model.dart';
import 'package:matties_app/features/boerenbridge/boerenbridge.dart';

class ManagePlayersButton extends StatelessWidget {
  const ManagePlayersButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: const Text('Matties toevoegen'),
      onPressed: () => _showDialog(context),
    );
  }

  void _showDialog(BuildContext parentContext) {
    showDialog<AlertDialog>(
      context: parentContext,
      builder: (context) {
        return BlocProvider.value(
          value: parentContext.read<BoerenbridgeBloc>(),
          child: BlocBuilder<BoerenbridgeBloc, BoerenbridgeState>(
            builder: (context, state) {
              return AlertDialog(
                actions: [
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Geried'),
                  ),
                ],
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Matties.values.length,
                    itemBuilder: (context, index) => CheckboxListTile(
                      title: Text(Matties.values[index].name),
                      value: state.players.contains(Matties.values[index]),
                      onChanged: (selected) =>
                          context.read<BoerenbridgeBloc>().add(
                                selected ?? false
                                    ? AddPlayerEvent(Matties.values[index])
                                    : RemovePlayerEvent(Matties.values[index]),
                              ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
