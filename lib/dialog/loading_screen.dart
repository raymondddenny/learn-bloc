import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testingbloc_course/dialog/loading_screen_controller.dart';

class LoadingScreen {
  // singleton pattern
  LoadingScreen._sharedInstance();
  static late final LoadingScreen _shared = LoadingScreen._sharedInstance();

  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  //API to show it in UI outside world
  void show({required BuildContext context, required String text}) {
    // check if the overlay is already showing
    if (_controller?.updateLoadingScreen(text) ?? false) {
      return;
    } else {
      // the overlay only will called once, until it removed
      _controller = _showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    _controller?.closeLoadingScreen();
    _controller = null; // make controller does not exist
  }

  LoadingScreenController _showOverlay({required BuildContext context, required String text}) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    // we user renderbox to understand the sizing of the overlay
    final renderBox = context.findRenderObject() as RenderBox;

    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150), //overlay bg color

          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<String>(
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                        stream: _text.stream,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // show the overlay to UI
    state?.insert(overlay);

    return LoadingScreenController(
      closeLoadingScreen: () {
        _text.close();
        overlay.remove();
        return true;
      },
      updateLoadingScreen: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
