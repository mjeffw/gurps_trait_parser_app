import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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

class CompositeTrait {
  static String generateText(List<Trait> traits) =>
      traits.map((it) => it.description).join(' + ');

  final String _text;
  final List<Trait> traits;
  final bool isParsed;

  String get rawText => _text;

  String get parsedText => generateText(traits);

  ///
  /// Either create a TraitModel given parseable text, or create one from a list
  /// of traits. You cannot do both.
  ///
  CompositeTrait({List<Trait> traits, bool isParsed})
      : traits = traits ?? [],
        _text = CompositeTrait.generateText(traits),
        isParsed = isParsed ?? true;

  factory CompositeTrait.copyWithTraits(CompositeTrait source,
          {List<Trait> traits, bool isParsed}) =>
      listEquals(source.traits, traits) && source.isParsed == isParsed
          ? source
          : CompositeTrait(
              isParsed: isParsed ?? source.isParsed, traits: traits ?? []);

  ///
  /// Either create a TraitModel given parseable text, or create one from a list
  /// of traits. You cannot do both.
  ///
  CompositeTrait.fromText({String text, bool isParsed})
      : _text = text ?? '',
        traits = _createTrait(text ?? ''),
        isParsed = isParsed ?? true;

  factory CompositeTrait.copyWithText(CompositeTrait source,
          {String text, bool isParsed}) =>
      (source.rawText == text && source.isParsed == isParsed)
          ? source
          : CompositeTrait.fromText(
              text: text ?? source._text,
              isParsed: isParsed ?? source.isParsed);

  factory CompositeTrait.remove(CompositeTrait source,
      {ModifierComponents modifier, Trait trait}) {
    List<Trait> traits = [];
    traits.addAll(source.traits);
    int index = traits.indexOf(trait);

    List<ModifierComponents> mods = []; // create temporary list
    mods.addAll(
        trait.modifiers); // copy all elements of trait.modifiers into temp list
    mods.remove(modifier); // remove the target modifier from temp list

    traits[index] = Trait.copyWith(trait, modifiers: mods);

    CompositeTrait model =
        CompositeTrait.copyWithTraits(source, traits: traits);
    return model;
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != this.runtimeType) return false;
    return this.rawText == other.rawText &&
        this.isParsed == other.isParsed &&
        listEquals(traits, other.traits);
  }

  @override
  int get hashCode => rawText.hashCode ^ isParsed.hashCode ^ traits.hashCode;
}

List<Trait> _createTrait(String text) {
  try {
    List<TraitComponents> components = Parser().parse(text);
    return components.map((it) => _buildTrait(it)).toList();
  } catch (exc) {
    return [];
  }
}

// TODO update Traits.buildTrait to return a shell trait if the template is not found
Trait _buildTrait(TraitComponents it) => Traits.buildTrait(it);
