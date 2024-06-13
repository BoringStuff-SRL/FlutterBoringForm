// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/boring_form.dart';
import 'package:boringcore/boringcore_responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension on List<String> {
  List<List<String>> nest(String splitter) =>
      map((e) => e.split(splitter)).toList();
}

class BoringForm extends BoringFormWidget {
  BoringForm(
      {super.key,
      BoringFormController? formController,
      super.style,
      required Widget child})
      : _child = child,
        super(formController: formController);

  BoringForm.responsive({
    super.key,
    BoringFormController? formController,
    required List<Widget> children,
    BoringResponsiveSize responsiveSize =
        const BoringResponsiveSize.defaultSizes(),
    super.style,
  })  : _child = BoringResponsiveLayout(
          children: children
              .map(
                (e) => e is BoringResponsiveChild
                    ? e
                    : BoringResponsiveChild(
                        responsiveSize: responsiveSize,
                        child: e,
                      ),
              )
              .toList(),
        ),
        super(formController: formController);

  final Widget _child;

  @override
  Widget get child => _child;
}

abstract class BoringResponsiveFormWidget extends BoringFormWidget {
  BoringResponsiveFormWidget({
    super.key,
    super.formController,
    super.style,
    BoringResponsiveSize responsiveSize =
        const BoringResponsiveSize.defaultSizes(),
  }) : _responsiveSize = responsiveSize;

  final BoringResponsiveSize _responsiveSize;

  List<Widget> get children;

  @override
  Widget get child => BoringResponsiveLayout(
        children: children
            .map(
              (e) => e is BoringResponsiveChild
                  ? e
                  : BoringResponsiveChild(
                      responsiveSize: _responsiveSize,
                      child: e,
                    ),
            )
            .toList(),
      );
}

abstract class BoringFormWidget extends StatelessWidget {
  final BoringFormController formController;
  Widget get child;
  final BoringFormStyle Function(BuildContext context)? style;
  BoringFormWidget(
      {super.key, BoringFormController? formController, this.style})
      : formController = formController ?? BoringFormController();

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: BoringFormTheme(
        style: style?.call(context) ?? BoringFormStyle(),
        child: ChangeNotifierProvider.value(
          value: formController,
          child: child,
        ),
      ),
    );
  }
}

class BoringFormChildWidget extends StatelessWidget {
  final List<List<String>> observedFields;
  final bool observeAllFields;
  final Widget Function(BuildContext context,
          BoringFormController formController /*TODO expose changed fields*/)?
      _builder;

  final FieldPath? childFieldPath;
  final Widget Function(
      BuildContext context,
      BoringFormController formController,
      FieldPath childFieldPath)? _withChildFieldPathBuilder;

  const BoringFormChildWidget(
      {super.key,
      this.observedFields = const [],
      required Widget Function(
        BuildContext context,
        BoringFormController formController,
      ) builder,
      this.observeAllFields = false})
      : childFieldPath = null,
        _withChildFieldPathBuilder = null,
        _builder = builder;

  const BoringFormChildWidget.withChildFieldPath(
      {super.key,
      this.observedFields = const [],
      required Widget Function(
        BuildContext context,
        BoringFormController formController,
        FieldPath childFieldPath,
      ) builder,
      required this.childFieldPath,
      this.observeAllFields = false})
      : _withChildFieldPathBuilder = builder,
        _builder = null;
  // BoringFormChildWidget.plain(
  //     {super.key,
  //     List<String> observedFields = const [],
  //     required this.builder})
  //     : observedFields = observedFields.nest(NESTING_CHAR);

  @override
  Widget build(BuildContext context) {
    return Selector<BoringFormController, List<dynamic>>(
        selector: (_, formController) {
      return observeAllFields
          ? [
              false,
              ...formController.valuePlain.entries.map((e) => e.value).toList()
            ]
          : formController.selectPaths(observedFields, includeError: false);
    }, builder: (context, _, __) {
      final formController =
          Provider.of<BoringFormController>(context, listen: false);

      if (_withChildFieldPathBuilder != null) {
        formController.setFieldValue(childFieldPath!, null);
        formController.removeValidationFunction(childFieldPath!);
        return _withChildFieldPathBuilder(
            context, formController, childFieldPath!);
      }

      return _builder!.call(context, formController);
    });
  }
}

typedef DecorationBuilder<T> = BoringFieldDecoration<T>? Function(
    BoringFormController formController);
