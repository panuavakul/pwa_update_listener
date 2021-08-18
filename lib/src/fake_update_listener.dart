import 'package:flutter/material.dart';
import 'package:pwa_update_listener/src/base_update_listener.dart';

/// Don't do anything when run with nonweb
void reloadPwa() {}

/// The fake placeholder widget use for when running on non-web project
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
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
