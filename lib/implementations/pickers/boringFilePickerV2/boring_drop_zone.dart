// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'package:boring_form/boring_form.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_drop_file_box.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_picker_settings.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BoringDropZone extends StatelessWidget {
  final BoringFormController formController;
  final List<String> fieldPath;
  late final ValueNotifier<Color> color;
  BoringDropZone(
      {super.key, required this.formController, required this.fieldPath});

  void _handlePick(
    List<PlatformFile> pickerResult,
    BoringFilePickerSettings settings,
  ) {
    if (pickerResult.isEmpty) {
      return;
    }
    switch (settings.decoration.boringFilePickerBehaviour) {
      case BoringFilePickerBehaviour.overwrite:
        formController.setFieldValue(fieldPath, pickerResult);
        break;
      case BoringFilePickerBehaviour.add:
        final files = formController.getValue(fieldPath) as List<PlatformFile>?;
        if (settings.decoration.allowMultiple) {
          formController.setFieldValue(fieldPath, (files ?? []) + pickerResult);
        } else {
          formController.setFieldValue(fieldPath, pickerResult);
        }
        break;
    }
  }

  Future<void> handleOnDragDone(BuildContext context,
      BoringFilePickerSettings settings, DropDoneDetails details) async {
    if (settings.readOnly) {
      return;
    }
    if (!settings.decoration.allowMultiple && details.files.length > 1) {
      settings.decoration.onError
          ?.call(context, BoringFilePickerErrorType.allowMultiple);
      return;
    }
    List<PlatformFile> files = [];
    for (DropItem e in details.files) {
      final bytes = await e.readAsBytes();
      final file = PlatformFile(
          name: e.name, size: bytes.lengthInBytes, bytes: bytes, path: e.path);
      if (!(settings.decoration.allowedExtensions?.contains(file.extension) ??
          true)) {
        settings.decoration.onError
            ?.call(context, BoringFilePickerErrorType.extension);
        return;
      }
      files.add(file);
    }
    _handlePick(files, settings);
  }

  @override
  Widget build(BuildContext context) {
    final settings = BoringFilePickerSettings.of(context);
    final decoration = settings.decoration;
    color = ValueNotifier(decoration.inActiveColor);
    return settings.decoration.dropzoneBuilder?.call(context, formController) ??
        DropTarget(
          onDragEntered: (details) {
            if (settings.readOnly) {
              return;
            }
            color.value = decoration.activeColor;
          },
          onDragExited: (details) {
            if (settings.readOnly) {
              return;
            }
            color.value = decoration.inActiveColor;
          },
          onDragDone: (details) {
            handleOnDragDone(context, settings, details);
          },
          child: ValueListenableBuilder(
            valueListenable: color,
            builder: (context, currentColor, child) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    if (settings.readOnly) {
                      return;
                    }
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: decoration.allowedExtensions == null
                                ? FileType.any
                                : FileType.custom,
                            allowMultiple: decoration.allowMultiple,
                            allowedExtensions: decoration.allowedExtensions,
                            withData: true);
                    _handlePick(result?.files ?? [], settings);
                  },
                  child: BoringDropFileBox(
                    decoration: decoration,
                    currentColor: currentColor,
                    child: Column(
                      children: [
                        decoration.hintIcon ??
                            Icon(
                              Icons.download,
                              color: currentColor,
                              size: 40,
                            ),
                        Text(
                          decoration.hintText ?? 'Drag and drop file or click',
                          style: decoration.hintTextStyle ??
                              TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: currentColor),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
  }
}
