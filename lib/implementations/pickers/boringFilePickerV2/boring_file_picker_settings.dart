// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_drop_zone_decoration.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_picker_v2.dart';
import 'package:flutter/material.dart';

class BoringFilePickerSettings extends InheritedWidget {
  final bool readOnly;
  final BoringFormController formController;
  final List<String> fieldPath;
  const BoringFilePickerSettings(
      {super.key,
      required this.decoration,
      required super.child,
      required this.formController,
      required this.fieldPath,
      required this.readOnly});

  final BoringFilePickerDecoration decoration;

  static BoringFilePickerSettings? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BoringFilePickerSettings>();
  }

  static BoringFilePickerSettings of(BuildContext context) {
    final BoringFilePickerSettings? result = maybeOf(context);
    assert(result != null, 'No BoringFilePickerSettings found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(BoringFilePickerSettings oldWidget) =>
      decoration != oldWidget.decoration;
}
