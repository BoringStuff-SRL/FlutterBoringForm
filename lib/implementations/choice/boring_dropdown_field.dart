// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BoringDropDownField<T> extends BoringField<T> {
  BoringDropDownField(
      {super.key,
      required super.jsonKey,
      required this.items,
      this.radius = 0,
      super.fieldController,
      super.decoration,
      super.displayCondition,
      super.boringResponsiveSize,
      bool? readOnly,
      super.onChanged,
      this.showEraseValueButton = true})
      : super(readOnly: readOnly);

  final List<DropdownMenuItem<T?>> items;
  final double radius;
  final bool showEraseValueButton;

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: ValueListenableBuilder(
          valueListenable: controller.autoValidate
              ? ValueNotifier(false)
              : controller.hideError,
          builder: (BuildContext context, bool value, Widget? child) {
            final InputDecoration newStyle =
                getDecoration(context, haveError: value)
                    .copyWith(contentPadding: const EdgeInsets.all(0));

            return Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField2<T?>(
                    dropdownOverButton: false,
                    isExpanded: true,
                    dropdownElevation: 0,
                    decoration: newStyle,
                    buttonHeight: 51,
                    itemHeight: 50,
                    dropdownMaxHeight: 250,
                    items: items,
                    value: controller.value,
                    hint: Text(
                      decoration?.hintText ?? '',
                      style: style.inputDecoration.hintStyle,
                    ),
                    dropdownDecoration: _boxDecoration(newStyle),
                    onChanged: isReadOnly(context)
                        ? null
                        : ((value) {
                            controller.value = value;
                          }),
                  ),
                ),
                if (showEraseValueButton && controller.value != null) ...[
                  const SizedBox(width: 5),
                  eraseButtonWidget(context, style.eraseValueWidget),
                ],
              ],
            );
          }),
    );
  }

  _boxDecoration(InputDecoration newStyle) => BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: newStyle.fillColor ?? Colors.white,
      border: Border.all(
          color: newStyle.border?.borderSide.color ?? Colors.grey,
          width: newStyle.border?.borderSide.width ?? 1));

  @override
  void onValueChanged(T? newValue) {}

  @override
  BoringDropDownField copyWith({
    BoringFieldController<T>? fieldController,
    void Function(T? p1)? onChanged,
    BoringFieldDecoration? decoration,
    BoringResponsiveSize? boringResponsiveSize,
    String? jsonKey,
    bool Function(Map<String, dynamic> p1)? displayCondition,
    List<DropdownMenuItem<dynamic>>? items,
    InputDecoration? searchInputDecoration,
    double? radius,
  }) {
    return BoringDropDownField(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: (onChanged as void Function(dynamic)?) ??
          (this.onChanged as void Function(dynamic)?),
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
      items: items ?? this.items,
    );
  }
}
