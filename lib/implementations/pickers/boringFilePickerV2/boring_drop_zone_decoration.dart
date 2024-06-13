// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';

class BoringFilePickerDecoration {
  final EdgeInsetsGeometry? dropZonePadding;
  final List<String>? allowedExtensions;
  final bool allowMultiple;
  final BorderRadius? borderRadius;
  final Border? border;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Icon? hintIcon;
  final Color inActiveColor;
  final Color activeColor;
  final Color onErrorColor;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final Function(BuildContext context, BoringFilePickerErrorType errorType)?
      onError;
  final Widget Function(
          BuildContext context, BoringFormController formController)?
      listTileBuilder;

  final Widget Function(
          BuildContext context, BoringFormController formController)?
      dropzoneBuilder;
  final BoringFilePickerBehaviour boringFilePickerBehaviour;

  const BoringFilePickerDecoration({
    this.dropZonePadding,
    this.borderRadius,
    this.border,
    this.hintText,
    this.hintTextStyle,
    this.hintIcon,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.inActiveColor = Colors.grey,
    this.activeColor = Colors.green,
    this.onErrorColor = Colors.red,
    this.allowMultiple = true,
    this.allowedExtensions,
    this.onError,
    this.listTileBuilder,
    this.dropzoneBuilder,
    this.boringFilePickerBehaviour = BoringFilePickerBehaviour.add,
  });
}

enum BoringFilePickerErrorType { extension, allowMultiple }

enum BoringFilePickerBehaviour { overwrite, add }
