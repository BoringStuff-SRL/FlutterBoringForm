// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_drop_file_box.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_picker_settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BoringFileListTile extends StatelessWidget {
  final PlatformFile file;

  const BoringFileListTile({Key? key, required this.file}) : super(key: key);

  SvgPicture fromExtensionToIcon(String extension) {
    switch (extension) {
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'webp':
        return SvgPicture.asset(
          'assets/img_format_icon.svg',
          package: 'boring_form',
        );

      case 'pdf':
        return SvgPicture.asset(
          'assets/pdf_format_icon.svg',
          package: 'boring_form',
        );

      case 'docx':
      case 'doc':
        return SvgPicture.asset(
          'assets/doc_format_icon.svg',
          package: 'boring_form',
        );

      case 'xls':
      case 'xlsx':
        return SvgPicture.asset(
          'assets/xls_format_icon.svg',
          package: 'boring_form',
        );

      case 'dwg':
        return SvgPicture.asset(
          'assets/dwg_format_icon.svg',
          package: 'boring_form',
        );
    }
    return SvgPicture.asset(
      'assets/no_format_icon.svg',
      package: 'boring_form',
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = BoringFilePickerSettings.of(context);
    final decoration = settings.decoration;
    final String extension = file.extension ?? '';
    return settings.decoration.listTileBuilder
            ?.call(context, settings.formController) ??
        BoringDropFileBox(
            decoration: decoration,
            currentColor: decoration.inActiveColor,
            child: Row(
              crossAxisAlignment:
                  decoration.crossAxisAlignment ?? CrossAxisAlignment.center,
              mainAxisAlignment: decoration.mainAxisAlignment ??
                  MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    fromExtensionToIcon(extension),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(file.name),
                    ),
                  ],
                ),
                if (!settings.readOnly)
                  IconButton(
                      onPressed: () {
                        final files = List<PlatformFile>.from(settings
                            .formController
                            .getValue(settings.fieldPath));

                        files.removeWhere(
                            (element) => element.name == file.name);

                        settings.formController.setFieldValue(
                            settings.fieldPath, files.isEmpty ? null : files);
                      },
                      icon: Icon(Icons.delete))
              ],
            ));
  }
}
