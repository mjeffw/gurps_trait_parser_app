import 'package:flutter_web/widgets.dart';
import 'package:gurps_traits/gurps_traits.dart';

class ModelBinding<T> extends StatefulWidget {
  ModelBinding({
    Key key,
    @required this.initialModel,
    this.child,
  })  : assert(initialModel != null),
        super(key: key);

  final T initialModel;
  final Widget child;

  _ModelBindingState createState() => _ModelBindingState<T>();

  static Type _typeOf<T>() => T;

  static T of<T>(BuildContext context) {
    final Type scopeType = _typeOf<_ModelBindingScope<T>>();
    final _ModelBindingScope<T> scope =
        context.inheritFromWidgetOfExactType(scopeType);
    return scope.modelBindingState.currentModel;
  }

  static void update<T>(BuildContext context, T newModel) {
    final Type scopeType = _typeOf<_ModelBindingScope<T>>();
    final _ModelBindingScope<dynamic> scope =
        context.inheritFromWidgetOfExactType(scopeType);
    scope.modelBindingState.updateModel(newModel);
  }
}

class _ModelBindingState<T> extends State<ModelBinding<T>> {
  T currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.initialModel;
  }

  void updateModel(T newModel) {
    if (newModel != currentModel) {
      setState(() {
        currentModel = newModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ModelBindingScope<T>(
      modelBindingState: this,
      child: widget.child,
    );
  }
}

class _ModelBindingScope<T> extends InheritedWidget {
  const _ModelBindingScope({Key key, this.modelBindingState, Widget child})
      : super(key: key, child: child);

  final _ModelBindingState<T> modelBindingState;

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}

Parser parser = Parser();

class TraitModel {
  String get text => _text;
  final String _text;
  final List<TraitComponents> components;

  TraitModel({String text})
      : _text = text ?? '',
        this.components = parser.tryParse(text ?? '');

  factory TraitModel.replaceText(TraitModel trait, {String text}) {
    return (trait.text == text) ? trait : TraitModel(text: text ?? trait.text);
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != this.runtimeType) return false;
    return this.text == other.text;
  }

  @override
  int get hashCode => text.hashCode;
}
