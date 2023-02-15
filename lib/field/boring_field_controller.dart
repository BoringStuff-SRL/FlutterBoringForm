import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

enum ChangedEvent { valueChanged, sumbittedForValidation }

enum ValidationType { always, onSubmit }

class BoringFieldController<T> extends ChangeNotifier {
  BoringFieldController({T? initialValue, this.validationFunction})
      : _initialValue = initialValue,
        _value = initialValue;

  BoringFieldController.withValue(
      {T? initialValue, this.validationFunction, required T? value})
      : _initialValue = initialValue,
        _value = value;

  BoringFieldController<T> copyWith(
      {T? initialValue,
      String? Function(T? value)? validationFunction,
      T? value}) {
    print("COPY FIELD CONTROLLER");
    print("CURRENT: $_value - PARAM; $value - NEW: ${value ?? _value}");
    return BoringFieldController.withValue(
        value: value ?? _value,
        initialValue: initialValue ?? this.initialValue,
        validationFunction: validationFunction ?? this.validationFunction);
  }

  T? _value;
  T? _initialValue;
  String? Function(T? value)? validationFunction;

  T? get value => _value;

  bool get changed =>
      !const DeepCollectionEquality().equals(value, _initialValue);

  set value(T? newValue) {
    setValueSilently(newValue);
    notifyListeners();
  }

  T? get initialValue => _initialValue;

  set initialValue(T? val) {
    _initialValue = val;
  }

  String? get errorMessage => validationFunction?.call(_value);

  void setValueSilently(T? newValue) {
    _value = newValue;
  }

  void sendNotification() => notifyListeners();

  bool get isValid => errorMessage == null;

  void reset() {
    _value = initialValue;
    notifyListeners();
  }
}
