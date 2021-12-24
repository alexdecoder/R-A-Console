import 'package:flutter/material.dart';

class DataWrapper extends InheritedWidget {
  final dynamic data;
  DataWrapper({Key? key, required child, required this.data})
      : assert(data != null),
        super(key: key, child: child);

  static DataWrapper? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DataWrapper>();

  @override
  bool updateShouldNotify(_) => false;
}
