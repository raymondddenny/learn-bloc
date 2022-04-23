import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/models/model.dart';
import 'package:collection/collection.dart';

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

  @override
  bool operator ==(covariant AppState other) {
    final otherPropertiesIsEqual =
        isLoading == other.isLoading && loginError == other.loginError && loginHandle == other.loginHandle;

    if (fetchNotes == null && other.fetchNotes == null) {
      return otherPropertiesIsEqual;
    } else {
      return otherPropertiesIsEqual && (fetchNotes?.isEqualTo(other.fetchNotes) ?? false);
    }
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        loginError,
        loginHandle,
        fetchNotes,
      );
}

extension UnOrderedEquality on Object {
  bool isEqualTo(other) => const DeepCollectionEquality.unordered().equals(
        this,
        other,
      );
}
