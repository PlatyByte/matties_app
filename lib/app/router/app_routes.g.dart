// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $playerSelectRoute,
    ];

RouteBase get $playerSelectRoute => GoRouteData.$route(
      path: '/',
      factory: $PlayerSelectRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'playing-game',
          factory: $PlayingGameRouteExtension._fromState,
        ),
      ],
    );

extension $PlayerSelectRouteExtension on PlayerSelectRoute {
  static PlayerSelectRoute _fromState(GoRouterState state) =>
      PlayerSelectRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PlayingGameRouteExtension on PlayingGameRoute {
  static PlayingGameRoute _fromState(GoRouterState state) => PlayingGameRoute();

  String get location => GoRouteData.$location(
        '/playing-game',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
