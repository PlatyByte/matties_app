import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matties_app/core/model/model.dart';
import 'package:matties_app/features/boerenbridge/boerenbridge.dart';
import 'package:matties_app/l10n/l10n.dart';

class PlayerSelectPage extends StatelessWidget {
  const PlayerSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<BoerenbridgeBloc, BoerenbridgeState>(
      listenWhen: (previous, current) =>
          previous is SelectingPlayersState && current is PlayingState,
      listener: (context, state) {
        // should navigate to playing page
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.playersSelectTitle),
        ),
        floatingActionButton: const ManagePlayersButton(),
        body: BlocBuilder<BoerenbridgeBloc, BoerenbridgeState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state.players.isEmpty) {
              return const Center(
                child: Text('Select some players to start'),
              );
            }
            return ReorderableListView(
              children: state.players
                  .map(
                    (player) => ListTile(
                      key: ValueKey<Matties>(player),
                      title: Text(player.name),
                    ),
                  )
                  .toList(),
              onReorder: (oldIndex, newIndex) =>
                  context.read<BoerenbridgeBloc>().add(
                        ReorderPlayerEvent(
                          oldIndex: oldIndex,
                          newIndex: newIndex,
                        ),
                      ),
            );
          },
        ),
      ),
    );
  }
}

class ManagePlayersButton extends StatelessWidget {
  const ManagePlayersButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Text('Players'),
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
                    child: const Text('Done'),
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
