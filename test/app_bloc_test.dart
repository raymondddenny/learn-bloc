import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_event.dart';
import 'package:testingbloc_course/bloc/app_state.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();
enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'initial state must be empty',
    build: () => AppBloc(
      urls: [],
    ),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
  );

  // 'Load valid data and compare state',
  blocTest<AppBloc, AppState>(
    'test to load a URL',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextImageUrl(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        imageData: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        imageData: text1Data,
        error: null,
      )
    ],
  );
  blocTest<AppBloc, AppState>(
    'test throw an error in url loader and catch it',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextImageUrl(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        imageData: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        imageData: null,
        error: Errors.dummy,
      )
    ],
  );

  blocTest<AppBloc, AppState>(
    'test loading two url images',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoadNextImageUrl(),
      );
      appBloc.add(
        const LoadNextImageUrl(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        imageData: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        imageData: text2Data,
        error: null,
      ),
      const AppState(
        isLoading: true,
        imageData: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        imageData: text2Data,
        error: null,
      )
    ],
  );
}
