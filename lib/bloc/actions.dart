import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppAction {
  const AppAction();
}

@immutable
class LoginAction implements AppAction {
  // it needs email and password to the action
  final String email;
  final String password;

  const LoginAction({
    required this.email,
    required this.password,
  });
}

@immutable
class LoadingNotesAction implements AppAction {
  const LoadingNotesAction();
}
