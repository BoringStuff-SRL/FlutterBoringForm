import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

//enum ChangedEvent { valueChanged, sumbittedForValidation }
enum ValidationBehaviour { always, onSubmit, never }

enum FieldRequiredLabelBehaviour {
  always,
  hiddenWhenValid,
  never;
}

class MapKeyListException implements Exception {
  int _errorIndex;
  final List<String> _fullPath;

  MapKeyListException(List<String> pathKeys)
      : _fullPath = pathKeys,
        _errorIndex = 0;

  void pushFieldLeft(String key) {
    _fullPath.insert(0, key);
    _errorIndex += 1;
  }

  List<String> get errorPath => _fullPath.getRange(0, _errorIndex).toList();
  @override
  String toString() {
    return "Field at path $errorPath is not a Map. Requested field: $_fullPath";
  }
}

//enum ValidationType { always, onSubmit }
extension on Map<String, dynamic> {
  bool pathExists(FieldPath path) {
    return true;
  }

  dynamic getValue(List<String> keysList) {
    if (keysList.isEmpty) {
      return null;
    }
    final key = keysList.first;
    if (!containsKey(key)) {
      return null;
    }
    final element = this[key];
    if (keysList.length == 1) {
      return element;
    }
    if (element is Map) {
      try {
        return (element as Map<String, dynamic>)
            .getValue(keysList.getRange(1, keysList.length).toList());
      } on MapKeyListException catch (e) {
        e.pushFieldLeft(key);
        rethrow;
      }
    }
    throw MapKeyListException(keysList);
  }

  void setValue(List<String> keysList, dynamic value) {
    if (keysList.isEmpty) {
      return;
    }
    final key = keysList.first;
    if (keysList.length == 1) {
      this[key] = value;
      return;
    }
    if (!containsKey(key)) {
      this[key] = <String, dynamic>{};
    }
    final element = this[key];
    if (element is Map) {
      try {
        (element as Map<String, dynamic>)
            .setValue(keysList.getRange(1, keysList.length).toList(), value);
      } on MapKeyListException catch (e) {
        e.pushFieldLeft(key);
        rethrow;
      }
    } else {
      throw MapKeyListException(keysList);
    }
  }

  void mergeValue(Map<String, dynamic> map, [bool mergeSubMaps = false]) {
    if (!mergeSubMaps) {
      addAll(map);
    }
    //TODO
    throw UnimplementedError();
  }

  void addEntry(MapEntry<String, dynamic> entry) {
    this[entry.key] = entry.value;
  }

  Map<String, dynamic> plain(String nestingChar) {
    final plainMap = <String, dynamic>{};
    for (var entry in entries) {
      if (entry.value is Map<String, dynamic>) {
        final toAdd = (entry.value as Map<String, dynamic>).plain(nestingChar);
        for (var newEntry in toAdd.entries) {
          final newKey = "${entry.key}$nestingChar${newEntry.key}";
          plainMap[newKey] = newEntry.value;
        }
      } else {
        plainMap.addEntry(entry);
      }
    }
    return plainMap;
  }
}

class BoringFormControllerValue extends ChangeNotifier {
  static const NESTING_CHAR = '.';
  static const DeepCollectionEquality _equality = DeepCollectionEquality();

  final Map<String, dynamic> _value;
  final Map<String, dynamic> initialValue;
  final ValidationBehaviour validationBehaviour;
  final FieldRequiredLabelBehaviour fieldRequiredLabelBehaviour;

  BoringFormControllerValue({
    Map<String, dynamic>? initialValue,
    this.validationBehaviour = ValidationBehaviour.onSubmit,
    this.fieldRequiredLabelBehaviour =
        FieldRequiredLabelBehaviour.hiddenWhenValid,
  })  : _value = initialValue ?? {},
        initialValue = initialValue ?? {};

  dynamic getValue(List<String> fieldPath, {dynamic defaultValue}) =>
      _value.getValue(fieldPath) ?? defaultValue;

  List<dynamic> _getMultiValues(List<List<String>> fieldPaths) =>
      fieldPaths.map((keysList) => _value.getValue(keysList)).toList();

  void setFieldValue<R>(List<String> fieldPath, R value) {
    dynamic old = _value.getValue(fieldPath);
    if (_equality.equals(old, value)) {
      return;
    }

    _value.setValue(fieldPath, value);
    // print(_value);

    notifyListeners();
  }

  Map<String, dynamic> get value => _value;

  set value(Map<String, dynamic> newValue) {
    if (_equality.equals(_value, newValue)) {
      return;
    }
    _value.clear();
    _value.addAll(newValue);
    notifyListeners();
  }

  // void mergeValue(Map<String, dynamic> map, [bool mergeSubMaps = false]) =>
  //     _value.mergeValue(map, mergeSubMaps);

  void reset() {
    value = initialValue;
  }

  bool get hasChanged =>
      !BoringFormControllerValue._equality.equals(_value, initialValue);

  //PLAIN VERSIONS OF METHODS
  dynamic getValuePlain(String fieldPath) =>
      getValue(fieldPath.split(NESTING_CHAR));

  List<dynamic> _getMultiValuesPlain(List<String> fieldPaths) =>
      _getMultiValues(fieldPaths.map((e) => e.split(NESTING_CHAR)).toList());

  void setFieldValuePlain(String fieldPath, dynamic value) =>
      setFieldValue(fieldPath.split(NESTING_CHAR), value);

  Map<String, dynamic> get valuePlain => _value.plain(NESTING_CHAR);
  //TODO only `set value` and `void mergeValue` don't have a plain version
}

typedef ValidationFunction<T> = String? Function(
    BoringFormController formController, T? value)?;
typedef FieldPath = List<String>;

class BoringFormController extends BoringFormControllerValue {
  // final Map<FieldPath, bool> _errors = {};

  final Map<FieldPath, ValidationFunction> _validationFunctions = {};
  BoringFormController({
    super.initialValue,
    super.validationBehaviour,
    super.fieldRequiredLabelBehaviour,
  });

  bool get isValid {
    if (!_isSubmitted) {
      _isSubmitted = true;
      notifyListeners();
    }
    return _validationFunctions.entries.every(
        (element) => element.value?.call(this, getValue(element.key)) == null);
    //return _errors.values.every((element) => element == false);
  }

  void setValidationFunction<T>(
      FieldPath fieldPath, ValidationFunction<T>? validationFunction) {
    _validationFunctions[fieldPath] = validationFunction != null
        ? ((controller, val) => validationFunction(controller, val as T?))
        : null;
  }

  void removeValidationFunction(FieldPath fieldPath) {
    _validationFunctions.removeWhere(
      (key, value) =>
          BoringFormControllerValue._equality.equals(key, fieldPath),
    );
  }

  String? _getFieldError(FieldPath fieldPath) =>
      _validationFunctions[fieldPath]?.call(this, getValue(fieldPath));

  String? getFieldError(FieldPath fieldPath) => _shouldShowError
      ? _validationFunctions[fieldPath]?.call(this, getValue(fieldPath))
      : null;

  bool _isSubmitted = false;

  bool get _shouldShowError =>
      validationBehaviour == ValidationBehaviour.always ||
      (validationBehaviour == ValidationBehaviour.onSubmit && _isSubmitted);

  List<dynamic> selectPaths(
          /*FieldPath fieldPath,*/ List<FieldPath> observedPaths,
          {required bool includeError}) =>
      [includeError && _shouldShowError, ..._getMultiValues(observedPaths)];
}
