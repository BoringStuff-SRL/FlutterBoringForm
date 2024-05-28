import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';

/// T è il tipo di valore del child
/// R è il tipo di valore del campo a cui sono connesso
class BoringConnectedField<T, R> extends BoringField<T> {
  BoringConnectedField({
    super.key,
    required String childJsonKey,
    required this.pathToConnectedJsonKey,
    required this.childBuilder,
    required this.formController,
    super.boringResponsiveSize,
    super.displayCondition,
  }) : super(
          jsonKey: childJsonKey,
        );

  final List<String> pathToConnectedJsonKey;
  final BoringField<T> Function(BuildContext context, R? connectedToValue)
      childBuilder;
  final BoringFormController formController;

  int get depth => pathToConnectedJsonKey.length - 1;

  BoringFieldController navigateThroughSection(
      BoringSectionController sectionController, int currentDepth) {
    late BoringFieldController result;

    sectionController.subControllers.forEach((key, value) {
      if (key == pathToConnectedJsonKey[currentDepth]) {
        if (value is BoringSectionController) {
          result = navigateThroughSection(value, ++currentDepth);
        } else {
          result = value;
        }
      }
    });

    return result;
  }

  bool hasSetInitialValue = false;

  @override
  Widget builder(BuildContext context, BoringFieldController<T> controller,
      Widget? child) {
    int currentDepth = 0;

    late BoringFieldController connectedToController;
    bool hasInitialValue = controller.initialValue != null;
    formController.subControllers.forEach((key, value) {
      if (key == pathToConnectedJsonKey[currentDepth]) {
        if (value is BoringSectionController) {
          connectedToController = navigateThroughSection(value, ++currentDepth);
        } else {
          connectedToController = value;
        }
      }
    });

    //BoringField<T>? oldChild;

    return ListenableBuilder(
      listenable: connectedToController,
      builder: (context, child) {
        controller.setValueSilently(null);
        // if (oldChild != null) {
        //   oldChild!.fieldController.value = null;
        // }
        final connectedToValue = connectedToController.value as R;

        final child = childBuilder.call(context, connectedToValue);

        controller.validationFunction =
            child.fieldController.validationFunction;

        final childHasInitialValueInController =
            child.fieldController.initialValue != null;
        if (childHasInitialValueInController) {
          controller.setValueSilently(child.fieldController.initialValue);
        }

        //oldChild = child;

        // child.fieldController.value = (null);
        assert(child.jsonKey == jsonKey, 'The jsonKeys must match');
        if (hasInitialValue && !hasSetInitialValue) {
          controller.validationFunction?.call(controller.value);
          controller.setValueSilently(controller.initialValue);
          child.setInitialValue(controller.initialValue);
          hasSetInitialValue = true;
        }

        controller.validationFunction?.call(child.fieldController.value);

        child.fieldController.addListener(() {
          controller.setValueSilently(child.fieldController.value);
        });

        return Container(key: GlobalKey(), child: child);
      },
    );
  }

  @override
  BoringConnectedField<T, R> copyWith({
    BoringFieldController<T>? fieldController,
    List<String>? pathToConnectedJsonKey,
    void Function(T? p1)? onChanged,
    BoringFieldDecoration? decoration,
    BoringResponsiveSize? boringResponsiveSize,
    String? jsonKey,
    bool Function(Map<String, dynamic> p1)? displayCondition,
    BoringField<T> Function(BuildContext, R?)? childBuilder,
    BoringFormController? formController,
  }) {
    return BoringConnectedField(
        childJsonKey: jsonKey ?? this.jsonKey,
        pathToConnectedJsonKey:
            pathToConnectedJsonKey ?? this.pathToConnectedJsonKey,
        childBuilder: childBuilder ?? this.childBuilder,
        formController: formController ?? this.formController);
  }
}