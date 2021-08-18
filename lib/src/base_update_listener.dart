import 'package:flutter/material.dart';

/// This is just an abstract class to ensure that the real/fake widget
/// has the same constructor
abstract class BaseUpdateListener extends StatefulWidget {
  const BaseUpdateListener({
    Key? key,
    required this.onReady,
    required this.child,
  }) : super(key: key);

  /// The callback, which will be called when a new update is ready
  final VoidCallback onReady;

  /// Your whatever widget, probably your main page
  final Widget child;
}
