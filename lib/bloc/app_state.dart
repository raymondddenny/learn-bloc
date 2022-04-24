import 'dart:typed_data' show Uint8List;

import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final Uint8List? imageData;
  final Object? error;
  const AppState({
    required this.isLoading,
    this.imageData,
    this.error,
  });

  // empty state
  const AppState.empty()
      : isLoading = false,
        imageData = null,
        error = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'hasData': imageData != null,
        'error': error,
      }.toString();

  @override
  bool operator ==(covariant AppState other) =>
      isLoading == other.isLoading && (imageData ?? []).isEqualTo(other.imageData ?? []) && error == other.error;

  @override
  int get hashCode => Object.hash(isLoading, imageData, error);
}

extension Comparison<E> on List<E> {
  bool isEqualTo(List<E> other) {
    if (identical(this, other)) {
      return true;
    }

    if (length != other.length) {
      return false;
    }

    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }

    return true;
  }
}
