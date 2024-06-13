// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_drop_zone.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_drop_zone_decoration.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_list_tile.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_picker_settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BoringFilePickerV2 extends BoringFormField<List<PlatformFile>> {
  final BoringFilePickerDecoration decoration;

  BoringFilePickerV2(
      {super.key,
      required super.fieldPath,
      super.observedFields,
      super.validationFunction,
      super.readOnly,
      this.decoration = const BoringFilePickerDecoration()});

  @override
  Widget builder(
      BuildContext context,
      BoringFormTheme formTheme,
      BoringFormController formController,
      List<PlatformFile>? fieldValue,
      String? error) {
    final bool readOnly = isReadOnly(formTheme);
    return BoringFilePickerSettings(
      readOnly: readOnly,
      decoration: decoration,
      formController: formController,
      fieldPath: fieldPath,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: fieldValue?.length ?? 0,
            itemBuilder: (context, index) {
              return BoringFileListTile(
                file: fieldValue![index],
              );
            },
          ),
          if (!readOnly)
            Row(
              children: [
                Expanded(
                  child: BoringDropZone(
                      formController: formController, fieldPath: fieldPath),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  void onSelfChange(
      BoringFormController formController, List<PlatformFile>? fieldValue) {}
}
