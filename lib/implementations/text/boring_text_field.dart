// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/boring_form_field.dart';
import 'package:flutter/material.dart';

class BoringTextField extends BoringFormField<String> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final int minLines;
  final int maxLines;
  final bool allowEmpty;

  BoringTextField({
    super.key,
    this.minLines = 1,
    this.maxLines = 1,
    this.allowEmpty = false,
    required super.fieldPath,
    super.observedFields,
    ValidationFunction<String>? validationFunction,
    super.decoration,
    super.readOnly,
    super.onChanged,
  }) : super(
            validationFunction: validationFunction == null && allowEmpty
                ? null
                : (BoringFormController formController, String? value) {
                    final error =
                        validationFunction?.call(formController, value);
                    final emptyError =
                        !allowEmpty && (value == null || value.isEmpty)
                            ? "Value cannot be empty"
                            : null;
                    return error ?? emptyError;
                  });

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  Widget builder(BuildContext context, BoringFormTheme formTheme,
      BoringFormController formController, String? fieldValue, String? errror) {
    return TextField(
      focusNode: _focusNode,
      readOnly: isReadOnly(formTheme),
      enabled: !isReadOnly(formTheme),
      controller: _textEditingController,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: formTheme.style.textAlign,
      style: formTheme.style.textStyle,
      decoration:
          getInputDecoration(formController, formTheme, errror, fieldValue),
      onChanged: (value) {
        setChangedValue(formController, value);
      },
    );
  }

  @override
  void onSelfChange(BoringFormController formController, String? fieldValue) {
    var cursorPos = _textEditingController.selection.base.offset;
    _textEditingController.text = (fieldValue ?? "");
    if (fieldValue != null) {
      _textEditingController.selection =
          TextSelection.collapsed(offset: cursorPos);
    }
  }

  // @override
  // bool setInitialValue(String? initialValue) {
  //   final v = super.setInitialValue(initialValue);
  //   if (v) {
  //     textEditingController.text = fieldController.value ?? "";
  //   }
  //   return v;
  // }

  // @override
  // Widget builder(context, controller, child) {
  //   // final style = getStyle(context);
  //   return TextField(
  //           // readOnly: isReadOnly(context),
  //           // enabled: !isReadOnly(context),
  //           controller: textEditingController,
  //           minLines: minLines,
  //           maxLines: maxLines,
  //           // textAlign: style.textAlign,
  //           // style: style.textStyle,
  //           // decoration: getDecoration(context, haveError: value),
  //           onChanged: ((value) {
  //             controller.value = value;
  //             controller.isValid;
  //           }),
  //         );

  // return BoringField.boringFieldBuilder(
  //   style,
  //   decoration?.label,
  //   child: ValueListenableBuilder(
  //     valueListenable: controller.autoValidate
  //         ? ValueNotifier(false)
  //         : controller.hideError,
  //     builder: (BuildContext context, bool value, Widget? child) {
  //       return TextField(
  //         readOnly: isReadOnly(context),
  //         enabled: !isReadOnly(context),
  //         controller: textEditingController,
  //         minLines: minLines,
  //         maxLines: maxLines,
  //         textAlign: style.textAlign,
  //         style: style.textStyle,
  //         decoration: getDecoration(context, haveError: value),
  //         onChanged: ((value) {
  //           controller.value = value;
  //           controller.isValid;
  //         }),
  //       );
  //     },
  //   ),
  // );
  // }

  // @override
  // void onValueChanged(String? newValue) {}

  // @override
  // BoringTextField copyWith(
  //     {BoringFieldController<String>? fieldController,
  //     void Function(String? p1)? onChanged,
  //     BoringFieldDecoration? decoration,
  //     BoringResponsiveSize? boringResponsiveSize,
  //     String? jsonKey,
  //     bool Function(Map<String, dynamic> p1)? displayCondition,
  //     bool? readOnly,
  //     int? minLines,
  //     int? maxLines}) {
  //   return BoringTextField(
  //     fieldController: fieldController ?? this.fieldController,
  //     onChanged: onChanged ?? this.onChanged,
  //     decoration: decoration ?? this.decoration,
  //     boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
  //     jsonKey: jsonKey ?? this.jsonKey,
  //     displayCondition: displayCondition ?? this.displayCondition,
  //     minLines: minLines ?? this.minLines,
  //     maxLines: maxLines ?? this.maxLines,
  //     readOnly: readOnly ?? this.readOnly,
  //   );
  // }
}
