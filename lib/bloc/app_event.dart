import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class LoadNextImageUrl implements AppEvent {
  const LoadNextImageUrl();
}
