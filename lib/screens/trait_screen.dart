import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gurps_trait_parser_app/theme.dart';
import 'package:gurps_traits/gurps_traits.dart';

import '../model/trait_text.dart';
import '../widgets/trait_text_editor.dart';

class TraitScreen extends StatelessWidget {
  static const String id = "trait_screen";

  @override
  Widget build(BuildContext context) {
    final CompositeTrait model = ModelBinding.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        children: [
          IndexedStack(
            index: model.isParsingText ? 1 : 0,
            children: [_TraitTextView(), TraitTextEditor(trait: model)],
          ),
          IconButton(
            icon: Icon(_icon(model), color: Colors.blue),
            iconSize: 48.0,
            onPressed: () => _toggleParsing(context, model),
          ),
          ..._traitComponents(context, model),
        ],
      ),
    );
  }

  IconData _icon(CompositeTrait model) =>
      model.isParsingText ? Icons.arrow_downward : Icons.arrow_upward;

  List<Widget> _traitComponents(BuildContext context, CompositeTrait model) =>
      _hasTraits(model)
          ? [
              Divider(),
              Flexible(
                child: ListView.builder(
                  itemCount: model.traits.length,
                  itemBuilder: (context, index) => ModelBinding(
                      child: _TraitCard(), initialModel: model.traits[index]),
                ),
              ),
            ]
          : [];

  bool _hasTraits(CompositeTrait model) =>
      model.traits != null && model.traits.isNotEmpty;

  void _toggleParsing(BuildContext context, CompositeTrait model) =>
      ModelBinding.update(context,
          CompositeTrait.copyWithText(model, isParsed: !model.isParsingText));
}

class _TraitTextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CompositeTrait model = ModelBinding.of<CompositeTrait>(context);

    final parsedText = model.parsedText;
    final TextEditingController controller =
        TextEditingController(text: parsedText);

    return buildTextField(controller: controller, enabled: false);
  }
}

class _TraitCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CompositeTrait model = ModelBinding.of<CompositeTrait>(context);
    final Trait trait = ModelBinding.of<Trait>(context);

    final focused = !model.isParsingText;
    final detail =
        '${trait.nameAndLevel} (${trait.specialization ?? ""}) [${trait.baseCost ?? 0}]';

    return Card(
      shape: _selectBorder(context, focused),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(trait.reference ?? ''),
            subtitle: Text('$detail\nModifier Total: ${trait.modifierTotal}%'),
            isThreeLine: true,
            trailing: Column(
              children: <Widget>[
                Text('Total Cost', style: smallLabelStyle),
                Text('${trait.cost}', style: largeLabelStyle)
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              if (!model.isParsingText)
                IconButton(
                  onPressed: () => _addEnhancement(model, trait),
                  icon: Icon(Icons.add_circle, color: Colors.blue),
                ),
              Divider(),
            ],
          ),
          //   if (isAddingModifier) _addModifierWidget(context, trait);
          ...?_buildAllModifierWidgets(trait),
        ],
      ),
    );
  }

  ShapeBorder _selectBorder(BuildContext context, bool focused) =>
      focused ? focusedBorder : Theme.of(context).cardTheme.shape;

  List<Widget> _buildAllModifierWidgets(Trait trait) {
    return trait.modifiers
        .map((it) => ModelBinding(initialModel: it, child: ModifierListTile()))
        .toList();
  }

  void _addEnhancement(CompositeTrait model, Trait trait) {
    // display add enhancement dialog
  }
}

class ModifierListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CompositeTrait model = ModelBinding.of<CompositeTrait>(context);
    final Trait trait = ModelBinding.of<Trait>(context);
    final Modifier modifier = ModelBinding.of<Modifier>(context);
    final focused = !model.isParsingText;

    final data = '${modifier.detail.isEmpty ? "" : modifier.detail + ", "}'
        '${modifier.value < 0 ? modifier.value : "+" + modifier.value.toString()}%';

    return Slidable(
      actionPane: SlidableStrechActionPane(),
      enabled: focused,
      actionExtentRatio: 0.2,
      child: ListTile(
        dense: true,
        title: Text(modifier.name),
        subtitle: Text(data),
        trailing: focused ? _MoreButton() : Text(''),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Cancel',
          color: Colors.grey,
          foregroundColor: Colors.white,
          icon: Icons.cancel,
          closeOnTap: true,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          closeOnTap: true,
          onTap: () {
            ModelBinding.update(context,
                CompositeTrait.remove(model, trait: trait, modifier: modifier));
          },
        ),
      ],
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert),
      iconSize: 20.0,
      onPressed: () {
        Slidable.of(context).open(actionType: SlideActionType.primary);
      },
    );
  }
}
