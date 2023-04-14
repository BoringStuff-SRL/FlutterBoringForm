import 'dart:convert';

import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:boring_form/field/boring_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:flutter/widgets.dart';

enum FeedbackPosition { top, left, right, bottom }

class BoringFilePicker extends BoringField<List<PlatformFile>> {
  BoringFilePicker(
      {required super.jsonKey,
      this.textSpacingFromIcon,
      this.borderRadius,
      this.buttonWidth,
      this.padding,
      this.backgroundColor,
      this.labelStyle,
      this.allowedExtensions,
      this.allowMultiple,
      this.verticalAlignment,
      this.noFilesSelectedText,
      this.feedbackPosition = FeedbackPosition.right,
      this.feedbackTextBuilder,
      this.mainAxisAlignment = MainAxisAlignment.start,
      super.fieldController,
      super.decoration,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged});

  final double? textSpacingFromIcon;
  final double? buttonWidth;
  final double? verticalAlignment;
  final TextStyle? labelStyle;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool? allowMultiple;
  final Text? noFilesSelectedText;
  final Text Function(int filesSelected)? feedbackTextBuilder;
  final List<String>? allowedExtensions;
  final FeedbackPosition feedbackPosition;
  final MainAxisAlignment mainAxisAlignment;

  Text _feedback(BoringFieldController<List<PlatformFile>> controller) =>
      controller.value == null
          ? noFilesSelectedText ?? const Text("No files selected")
          : feedbackTextBuilder?.call(controller.value!.length) ??
              Text("${controller.value!.length} files selected");

  @override
  Widget builder(BuildContext context, controller, Widget? child) {
    final style = getStyle(context);

    bool readOnly = style.readOnly;

    return BoringField.boringFieldBuilder(
      style,
      "",
      excludeLabel: true,
      child: Align(
        heightFactor: verticalAlignment ?? 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            if (feedbackPosition == FeedbackPosition.left)
              Row(
                children: [
                  _feedback(controller),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (feedbackPosition == FeedbackPosition.top)
                  Column(
                    children: [
                      _feedback(controller),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                MouseRegion(
                  cursor:
                      !readOnly ? SystemMouseCursors.click : MouseCursor.defer,
                  child: GestureDetector(
                    onTap: !readOnly
                        ? () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: allowedExtensions == null
                                  ? FileType.any
                                  : FileType.custom,
                              allowMultiple: allowMultiple ?? true,
                              allowedExtensions: allowedExtensions,
                            );

                            if (result != null) {
                              controller.value = result.files;
                            } else {
                              // User canceled the picker
                            }
                          }
                        : () {},
                    child: Container(
                      padding:
                          padding ?? const EdgeInsets.symmetric(vertical: 7),
                      width: buttonWidth ?? 100,
                      decoration: BoxDecoration(
                        color: backgroundColor ?? Colors.green,
                        borderRadius: borderRadius ?? BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          decoration?.prefixIcon ?? const Icon(Icons.file_open),
                          SizedBox(
                            width: textSpacingFromIcon ?? 5,
                          ),
                          Text(
                            decoration?.label ?? "Pick file",
                            style: labelStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (feedbackPosition == FeedbackPosition.bottom)
                  Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      _feedback(controller),
                    ],
                  ),
              ],
            ),
            const SizedBox(
              width: 5,
            ),
            if (feedbackPosition == FeedbackPosition.right)
              _feedback(controller),
          ],
        ),
      ),
    );
  }

  @override
  BoringField copyWith(
      {BoringFieldController<List<PlatformFile>>? fieldController,
      void Function(List<PlatformFile>? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}