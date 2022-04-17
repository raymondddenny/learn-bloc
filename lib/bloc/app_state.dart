import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/models/model.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchNotes;

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchNotes = null;

  const AppState({
    required this.isLoading,
    this.loginError,
    this.loginHandle,
    this.fetchNotes,
  });

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginError': loginError,
        'loginHandle': loginHandle,
        'fetchNotes': fetchNotes,
      }.toString();
}
