import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:pwa_update_listener/src/base_update_listener.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// `onVisibilityChange` event
/// This is used to check for when app is in the back/foreground
/// https://developer.mozilla.org/en-US/docs/Web/API/Document/onvisibilitychange
const _visibilityChangeEvent = 'visibilitychange';

/// https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration/onupdatefound
const _updateFoundEvent = 'updatefound';

/// https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorker/onstatechange
const _stateChangeEvent = 'statechange';

/// Just a key to check if the app is visible
const _visibleState = 'visible';

/// A helper function to reload your PWA
void reloadPwa() {
  html.window.location.reload();
}

/// This widget is used to detect if a new version of PWA is ready so that
/// you can notify the user and update the current version to the newest version
/// It check for the new version under 2 conditions
/// 1) When the child widget is visible after not visible, this include when
///  a page is popped and the child widget is shown
/// 2) When the page with child widget is active and the app become foreground after
///  in background
class PwaUpdateListener extends BaseUpdateListener {
  const PwaUpdateListener({
    Key? key,

    /// The callback, which will be called when a new update is ready
    required VoidCallback onReady,

    /// Your whatever widget, probably your main page
    required Widget child,
  }) : super(
          key: key,
          onReady: onReady,
          child: child,
        );

  @override
  _PwaUpdateListenerState createState() => _PwaUpdateListenerState();
}

class _PwaUpdateListenerState extends State<PwaUpdateListener> {
  static const _visibilityDetectorKey = Key('visibility_detector_key');

  /// This is used to check if the child widget is currently visible
  /// If this is 0 that mean child isn't shown and if it is not 0 then it maen that
  /// it is visible somewhere in the app
  double _visibility = 1;

  /// The serviceWorker registration
  html.ServiceWorkerRegistration? _serviceWorkerRegistration;

  /// Check if app is in the fore/background
  void _visibilityChangeListener(html.Event event) {
    final visibilityState = html.window.document.visibilityState;
    if (visibilityState == _visibleState) {
      /// App became foreground
      _serviceWorkerRegistration?.update();
    }
  }

  /// Get the current service worker and register eventListener
  Future<void> _registerServiceWorker() async {
    _serviceWorkerRegistration =
        await html.window.navigator.serviceWorker?.getRegistration();

    _serviceWorkerRegistration?.addEventListener(_updateFoundEvent, (event) {
      _serviceWorkerRegistration?.installing?.addEventListener(
        _stateChangeEvent,
        (event) {
          if (_serviceWorkerRegistration?.waiting != null) {
            widget.onReady();
          }
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _registerServiceWorker();

    html.window
        .addEventListener(_visibilityChangeEvent, _visibilityChangeListener);
  }

  @override
  void dispose() {
    html.window.removeEventListener(
      _visibilityChangeEvent,
      _visibilityChangeListener,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// `VisibilityDetector` is used to check if the child widget is visible
    /// I just thought that it is an easy way of checking if the child widget is
    /// shown again after another page is popped
    return VisibilityDetector(
      key: _visibilityDetectorKey,
      onVisibilityChanged: (visibilityInfo) {
        if (_visibility == 0 && visibilityInfo.visibleFraction > 0) {
          _serviceWorkerRegistration?.update();
        }
        _visibility = visibilityInfo.visibleFraction;
      },
      child: widget.child,
    );
  }
}
