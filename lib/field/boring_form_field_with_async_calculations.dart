// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable

import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/boring_form_field_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BoringFormFieldWithAsyncCalculations<T, TT>
    extends BoringFormFieldBase<T, Future<TT>> {
  const BoringFormFieldWithAsyncCalculations({
    super.key,
    required super.fieldPath,
    super.observedFields = const [],
    super.validationFunction,
    super.decoration,
    super.readOnly,
  });

  // @override
  // Widget baseBuilder(
  //         BuildContext context,
  //         BoringFormTheme formTheme,
  //         BoringFormController formController,
  //         T? fieldValue,
  //         String? errror,
  //         Future<TT> calculations) =>
  //     builder(
  //         context, formTheme, formController, fieldValue, errror, calculations);

  Widget builder(
      BuildContext context,
      BoringFormTheme formTheme,
      BoringFormController formController,
      T? fieldValue,
      String? error,
      AsyncSnapshot<TT> calculations);

  @override
  Future<TT> onObservedFieldsChange(BoringFormController formController);

  @override
  void onSelfChange(BoringFormController formController, T? fieldValue);

  @override
  Widget build(BuildContext context) {
    final formController =
        Provider.of<BoringFormController>(context, listen: false);
    final formTheme = BoringFormTheme.of(context);
    final fieldDecoration = getFieldDecoration(formController);
    formController.setValidationFunction(fieldPath, validationFunction);
    return Selector<BoringFormController, List<dynamic>>(
        selector: (_, formController) =>
            formController.selectPaths(observedFields, includeError: true),
        builder: (context, _, __) {
          final calculations = onObservedFieldsChange(formController);
          return FutureBuilder(
            future: calculations,
            builder: (context, snapshot) {
              return Selector<
                      BoringFormController, // T?>(
                      ({T? fieldValue, String? error})>(
                  selector: (_, formController) => (
                        fieldValue: formController.getValue(fieldPath) as T?,
                        error: formController.getFieldError(fieldPath)
                      ),
                  builder: (context, value, child) {
                    onSelfChange(formController, value.fieldValue);
                    return Padding(
                      padding: formTheme.style.fieldsPadding,
                      child: Column(
                        children: [
                          if (formTheme.style.labelOverField &&
                              fieldDecoration?.label != null)
                            labelOverField(formTheme, fieldDecoration!,
                                formController, formTheme.style),
                          builder(context, formTheme, formController,
                              value.fieldValue, value.error, snapshot),
                        ],
                      ),
                    );
                  });
            },
          );
        });
  }
}
