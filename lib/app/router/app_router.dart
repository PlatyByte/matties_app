import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matties_app/app/router/router.dart';

class AppRouter {
  static GoRouter router({Listenable? refreshListenable}) => GoRouter(
        initialLocation: PlayerSelectRoute().location,
        refreshListenable: refreshListenable,
        routes: $appRoutes,
      );
}
