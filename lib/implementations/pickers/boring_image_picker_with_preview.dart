import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';

class BoringImagePickerWithPreviewDecoration {
  final BoxDecoration Function(bool hasValue)? boxDecoration;
  final EdgeInsets Function(bool hasValue)? boxPadding;
  final Widget? selectImagesWidget;

  final String? selectImageText;
  final Widget? selectImageIcon;
  final Color? selectImageColor;

  final Widget Function(BuildContext context, Widget child) _selectImageWrapper;
  final Widget Function(BuildContext context, Widget child)
      _previewImageWrapper;

  BoringImagePickerWithPreviewDecoration({
    this.boxDecoration,
    this.boxPadding,
    this.selectImagesWidget,
    this.selectImageText,
    this.selectImageIcon,
    this.selectImageColor,
    Widget Function(BuildContext context, Widget child)? selectImageWrapper,
    Widget Function(BuildContext context, Widget child)? previewImageWrapper,
  })  : _selectImageWrapper = selectImageWrapper ?? ((context, child) => child),
        _previewImageWrapper =
            previewImageWrapper ?? ((context, child) => child);
}

class BoringImagePickerWithPreview extends BoringFormField<Uint8List> {
  BoringImagePickerWithPreview(
      {required super.fieldPath,
      super.onChanged,
      super.decoration,
      super.observedFields,
      super.key,
      super.readOnly,
      super.validationFunction,
      BoringImagePickerWithPreviewDecoration? imagePickerWithPreviewDecoration})
      : imagePickerWithPreviewDecoration = imagePickerWithPreviewDecoration ??
            BoringImagePickerWithPreviewDecoration(),
        _imagePickerWithPreviewBuilders = _BoringImagePickerWithPreviewBuilders(
            imagePickerWithPreviewDecoration ??
                BoringImagePickerWithPreviewDecoration());

  final BoringImagePickerWithPreviewDecoration imagePickerWithPreviewDecoration;
  final _BoringImagePickerWithPreviewBuilders _imagePickerWithPreviewBuilders;

  @override
  Widget builder(
      BuildContext context,
      BoringFormTheme formTheme,
      BoringFormController formController,
      Uint8List? fieldValue,
      String? error) {
    final hasValue = fieldValue != null;

    final boxDecoration =
        _imagePickerWithPreviewBuilders.buildBoxDecoration(hasValue);

    return ClipRRect(
      borderRadius: boxDecoration.borderRadius ?? BorderRadius.zero,
      child: Container(
        padding: _imagePickerWithPreviewBuilders.buildBoxPadding(hasValue),
        decoration: boxDecoration,
        child: !hasValue
            ? _emptyValueWidget(context, formController)
            : _imagePreviewWidget(context, formController),
      ),
    );
  }

  Widget _emptyValueWidget(
      BuildContext context, BoringFormController formController) {
    final child = _clickToPickWidget(
      formController: formController,
      child: _imagePickerWithPreviewBuilders.buildSelectImagesWidget(context),
    );

    return _imagePickerWithPreviewBuilders.buildEmptyValueWidget(
        context, child);
  }

  Widget _imagePreviewWidget(
      BuildContext context, BoringFormController formController) {
    final image = Image.memory(
      formController.getValue(fieldPath) as Uint8List,
      fit: BoxFit.contain,
    );
    final child = Stack(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: PinchZoomReleaseUnzoomWidget(
                    child: image,
                  ),
                ),
              );
            },
            child: image,
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: IconButton(
              onPressed: () async {
                await _handleSelectImage(formController);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ],
    );

    return _imagePickerWithPreviewBuilders.buildImagePreviewWidget(
        context, child);
  }

  Widget _clickToPickWidget(
          {required BoringFormController formController,
          required Widget child}) =>
      Builder(builder: (context) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              await _handleSelectImage(formController);
            },
            child: child,
          ),
        );
      });

  Future<void> _handleSelectImage(BoringFormController formController) async {
    final selectedFileResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.image,
    );

    if (selectedFileResult != null) {
      formController.setFieldValue(
          fieldPath, selectedFileResult.files.first.bytes!);
    }
  }

  @override
  void onSelfChange(
      BoringFormController formController, Uint8List? fieldValue) {}
}

class _BoringImagePickerWithPreviewBuilders {
  BoringImagePickerWithPreviewDecoration imagePickerWithPreviewDecoration;

  _BoringImagePickerWithPreviewBuilders(this.imagePickerWithPreviewDecoration);

  BoxDecoration buildBoxDecoration(bool hasValue) =>
      imagePickerWithPreviewDecoration.boxDecoration?.call(hasValue) ??
      BoxDecoration(
          border: !hasValue ? Border.all(color: Colors.grey, width: 1) : null,
          borderRadius: BorderRadius.circular(15));

  EdgeInsets buildBoxPadding(bool hasValue) =>
      imagePickerWithPreviewDecoration.boxPadding?.call(hasValue) ??
      (hasValue ? EdgeInsets.zero : const EdgeInsets.all(15));

  Widget buildSelectImagesWidget(BuildContext context) =>
      imagePickerWithPreviewDecoration.selectImagesWidget ??
      Column(
        children: [
          imagePickerWithPreviewDecoration.selectImageIcon ??
              Icon(
                Icons.upload,
                color: Theme.of(context).colorScheme.primary,
                size: 35,
              ),
          const SizedBox(height: 10),
          Text(
            imagePickerWithPreviewDecoration.selectImageText ?? "Select image",
            style: TextStyle(
                color: imagePickerWithPreviewDecoration.selectImageColor ??
                    Colors.grey),
          )
        ],
      );

  Widget buildEmptyValueWidget(BuildContext context, Widget child) =>
      imagePickerWithPreviewDecoration._selectImageWrapper.call(context, child);

  Widget buildImagePreviewWidget(BuildContext context, Widget child) =>
      imagePickerWithPreviewDecoration._previewImageWrapper
          .call(context, child);
}
