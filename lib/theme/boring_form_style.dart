// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BoringFormStyle {
  final InputDecoration inputDecoration;
  final bool labelOverField;
  final AlignmentGeometry labelOverFieldAlignment;
  final EdgeInsets? labelOverFieldPadding;
  final TextStyle sectionTitleStyle;
  final EdgeInsetsGeometry fieldsPadding;
  final TextStyle formTitleStyle;
  final bool readOnly;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final BoxDecoration? sectionBoxDecoration;
  final EdgeInsets? sectionPadding;
  final EdgeInsets? sectionMargin;
  final Widget eraseValueWidget;
  final Widget? fieldRequiredLabelWidget;

  BoringFormStyle(
      {this.fieldsPadding = const EdgeInsets.all(8),
      this.sectionTitleStyle = const TextStyle(),
      this.labelOverFieldPadding,
      this.formTitleStyle = const TextStyle(),
      this.inputDecoration = const InputDecoration(),
      this.labelOverField = false,
      this.readOnly = false,
      this.labelOverFieldAlignment = Alignment.centerLeft,
      this.sectionPadding,
      this.sectionMargin,
      this.textStyle,
      this.sectionBoxDecoration,
      this.textAlign = TextAlign.start,
      this.fieldRequiredLabelWidget,
      this.eraseValueWidget = const Icon(Icons.close)})
      : assert(inputDecoration.label == null, _getFieldAssertionError("label")),
        assert(inputDecoration.icon == null, _getFieldAssertionError("icon")),
        assert(inputDecoration.helperText == null,
            _getFieldAssertionError("helperText")),
        assert(inputDecoration.hintText == null,
            _getFieldAssertionError("hintText")),
        assert(inputDecoration.counter == null,
            _getFieldAssertionError("counter")),
        assert(
            inputDecoration.prefix == null, _getFieldAssertionError("prefix")),
        assert(inputDecoration.prefixIcon == null,
            _getFieldAssertionError("prefixIcon")),
        assert(inputDecoration.prefixText == null,
            _getFieldAssertionError("prefixText")),
        assert(
            inputDecoration.suffix == null, _getFieldAssertionError("suffix")),
        assert(inputDecoration.suffixIcon == null,
            _getFieldAssertionError("suffixIcon")),
        assert(inputDecoration.suffixText == null,
            _getFieldAssertionError("suffixText"));

  static String _getFieldAssertionError(String field) =>
      "InputDecoration '$field' property not allowed inside BoringFormStyle: the '$field' property will be inherited from each field!";

  BoringFormStyle copyWith({
    InputDecoration? inputDecoration,
    bool? labelOverField,
    TextStyle? sectionTitleStyle,
    EdgeInsetsGeometry? fieldsPadding,
    TextStyle? formTitleStyle,
    bool? readOnly,
    TextAlign? textAlign,
    TextStyle? textStyle,
    BoxDecoration? sectionBoxDecoration,
    EdgeInsets? sectionPadding,
    EdgeInsets? sectionMargin,
  }) {
    return BoringFormStyle(
      inputDecoration: inputDecoration ?? this.inputDecoration,
      labelOverField: labelOverField ?? this.labelOverField,
      sectionTitleStyle: sectionTitleStyle ?? this.sectionTitleStyle,
      fieldsPadding: fieldsPadding ?? this.fieldsPadding,
      formTitleStyle: formTitleStyle ?? this.formTitleStyle,
      readOnly: readOnly ?? this.readOnly,
      textAlign: textAlign ?? this.textAlign,
      textStyle: textStyle ?? this.textStyle,
      sectionBoxDecoration: sectionBoxDecoration ?? this.sectionBoxDecoration,
      sectionMargin: sectionMargin ?? this.sectionMargin,
      sectionPadding: sectionPadding ?? this.sectionPadding,
    );
  }
}
