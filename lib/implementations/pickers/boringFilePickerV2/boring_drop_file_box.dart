// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_drop_zone_decoration.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_picker_v2.dart';
import 'package:flutter/material.dart';

class BoringDropFileBox extends StatelessWidget {
  final Widget child;
  final BoringFilePickerDecoration decoration;
  final Color currentColor;
  const BoringDropFileBox(
      {Key? key,
      required this.child,
      required this.decoration,
      required this.currentColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: decoration.dropZonePadding ?? EdgeInsets.all(20),
      margin: EdgeInsets.all(4),
      child: child,
      decoration: BoxDecoration(
          borderRadius:
              decoration.borderRadius ?? BorderRadius.all(Radius.circular(10)),
          border:
              decoration.border ?? Border.all(color: currentColor, width: 1)),
    );
  }
}
