import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matties_app/app/router/app_router.dart';
import 'package:matties_app/features/boerenbridge/boerenbridge.dart';
import 'package:matties_app/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoerenbridgeBloc>(create: (_) => BoerenbridgeBloc()),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.router(
        refreshListenable: Listenable.merge([
          context.read<BoerenbridgeBloc>(),
        ]),
      ),
    );
  }
}
