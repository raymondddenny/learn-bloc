import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/app_event.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'dart:math' as math;

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);
typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  // if AppBlocRandomUrlPicker is null then we gonna run this function
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();
  Future<Uint8List> _loadUrl(String url) =>
      NetworkAssetBundle(Uri.parse(url)).load(url).then((byteData) => byteData.buffer.asUint8List());

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
    AppBlocUrlLoader? urlLoader,
  }) : super(
          const AppState.empty(),
        ) {
    // start loading when app running
    on<LoadNextImageUrl>((event, emit) async {
      emit(const AppState(isLoading: true, imageData: null, error: null));

      final url = urlPicker != null ? urlPicker(urls) : _pickRandomUrl(urls);

      try {
        if (waitBeforeLoading != null) {
          await Future.delayed(waitBeforeLoading);
        }

        final data = await (urlLoader ?? _loadUrl)(url);

        emit(
          AppState(
            isLoading: false,
            error: null,
            imageData: data,
          ),
        );
      } catch (e) {
        emit(
          AppState(
            isLoading: false,
            imageData: null,
            error: e,
          ),
        );
      }
    });
  }
}
