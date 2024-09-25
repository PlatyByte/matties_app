import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChangeNotifierBloc<Event, State> extends Bloc<Event, State>
    with ChangeNotifier {
  ChangeNotifierBloc(
    super.initialState, {
    this.notifyGuard,
  });

  final bool Function(Change<State>)? notifyGuard;

  @override
  void onChange(Change<State> change) {
    super.onChange(change);
    if (true == notifyGuard?.call(change)) {
      notifyListeners();
    }
  }
}
