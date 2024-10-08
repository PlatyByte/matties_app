import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:matties_app/features/boerenbridge/boerenbridge.dart';

part 'app_routes.g.dart';

@TypedGoRoute<PlayerSelectRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<PlayingGameRoute>(
      path: 'playing-game',
    ),
  ],
)
class PlayerSelectRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PlayerSelectPage();

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final gameState = context.read<BoerenbridgeBloc>().state;

    if (gameState is PlayingState) {
      return PlayingGameRoute().location;
    }

    return null;
  }
}

class PlayingGameRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PlayingGamePage();

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final gameState = context.read<BoerenbridgeBloc>().state;

    if (gameState is! PlayingState) {
      return PlayerSelectRoute().location;
    }

    return null;
  }
}
