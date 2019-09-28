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

class TraitDelegate extends Trait {
  final Trait trait;

  TraitDelegate({this.trait});

  List<Modifier> get modifiers => trait.modifiers;

  String get reference => trait.reference;
  String get description => trait.description;
  String get nameAndLevel => trait.nameAndLevel;
  String get specialization => trait.specialization;
  int get cost => trait.cost;
  int get baseCost => trait.baseCost;
  int get modifierTotal => trait.modifierTotal;

  Trait copyWith({List<Modifier> modifiers}) =>
      TraitDelegate(trait: trait.copyWith(modifiers: modifiers));
}

class CompositeTrait {
  static String generateText(List<Trait> traits) =>
      traits.map((it) => it.description).join(' + ');

  final String _text;
  final List<Trait> traits;
  final bool isParsingText;

  String get rawText => _text;

  String get parsedText => generateText(traits);

  ///
  /// Either create a TraitModel given parseable text, or create one from a list
  /// of traits. You cannot do both.
  ///
  CompositeTrait({List<Trait> traits, bool isParsed})
      : traits = traits ?? [],
        _text = CompositeTrait.generateText(traits),
        isParsingText = isParsed ?? true;

  factory CompositeTrait.copyWithTraits(CompositeTrait source,
          {List<Trait> traits, bool isParsed}) =>
      listEquals(source.traits, traits) && source.isParsingText == isParsed
          ? source
          : CompositeTrait(
              isParsed: isParsed ?? source.isParsingText, traits: traits ?? []);

  ///
  /// Either create a TraitModel given parseable text, or create one from a list
  /// of traits. You cannot do both.
  ///
  CompositeTrait.fromText({String text, bool isParsed})
      : _text = text ?? '',
        traits = _createTrait(text ?? ''),
        isParsingText = isParsed ?? true;

  factory CompositeTrait.copyWithText(CompositeTrait source,
          {String text, bool isParsed}) =>
      (source.rawText == text && source.isParsingText == isParsed)
          ? source
          : CompositeTrait.fromText(
              text: text ?? source._text,
              isParsed: isParsed ?? source.isParsingText);

  factory CompositeTrait.remove(CompositeTrait source,
      {Modifier modifier, Trait trait}) {
    List<Modifier> mods = [];
    mods.addAll(trait.modifiers);
    mods.remove(modifier);

    List<Trait> traits = [];
    traits.addAll(source.traits);
    int index = traits.indexOf(trait);
    traits[index] = trait.copyWith(modifiers: mods);

    CompositeTrait model =
        CompositeTrait.copyWithTraits(source, traits: traits);
    return model;
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != this.runtimeType) return false;
    return this.rawText == other.rawText &&
        this.isParsingText == other.isParsingText &&
        listEquals(traits, other.traits);
  }

  @override
  int get hashCode =>
      rawText.hashCode ^ isParsingText.hashCode ^ traits.hashCode;
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
TraitDelegate _buildTrait(TraitComponents it) =>
    TraitDelegate(trait: Traits.buildTrait(it));
