import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen closeLoadingScreen;
  final UpdateLoadingScreen updateLoadingScreen;

  const LoadingScreenController({
    required this.closeLoadingScreen,
    required this.updateLoadingScreen,
  });
}
