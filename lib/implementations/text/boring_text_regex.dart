import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/implementations/text/boring_text_field.dart';

class BoringTextRegExpField extends BoringTextField {
  BoringTextRegExpField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    ValidationFunction<String>? validationFunction,
    super.decoration,
    super.readOnly,
    super.maxLines,
    super.minLines,
    super.allowEmpty,
    required RegExp regExp,
    required String regExpError,
  }) : super(
            validationFunction: validationFunction == null && allowEmpty
                ? null
                : (BoringFormController formController, String? value) {
                    final error =
                        validationFunction?.call(formController, value);
                    if (error != null) {
                      return error;
                    }
                    if (!regExp.hasMatch(value ?? '')) {
                      if (allowEmpty && (value ?? '').isEmpty) {
                        return null;
                      }
                      return regExpError;
                    }
                    return null;
                  });
  // BoringTextRegExpField(
  //     {super.key,
  //     BoringFieldController<String>? fieldController,
  //     super.onChanged,
  //     required super.jsonKey,
  //     this.canEmpty = false,
  //     super.readOnly,
  //     super.boringResponsiveSize,
  //     required String regExpError,
  //     super.displayCondition,
  //     required RegExp regExp,
  //     super.decoration})
  //     : super(
  //           fieldController:
  //               (fieldController ?? BoringFieldController<String>()).copyWith(
  //         validationFunction: (value) {
  //           if (!canEmpty) {
  //             if (value == null || value.isEmpty || !regExp.hasMatch(value)) {
  //               return regExpError;
  //             }
  //           } else {
  //             if (value != null && value.isNotEmpty) {
  //               if (!regExp.hasMatch(value)) {
  //                 return regExpError;
  //               }
  //             }
  //           }

  //           return fieldController?.validationFunction?.call(value);
  //         },
  //       ));

  // final bool canEmpty;
}
