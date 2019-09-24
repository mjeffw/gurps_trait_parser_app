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
            index: model.isParsed ? 1 : 0,
            children: [
              _TraitTextView(),
              TraitTextEditor(trait: model),
            ],
          ),
          IconButton(
            icon: Icon(
              model.isParsed ? Icons.arrow_downward : Icons.arrow_upward,
              color: Colors.blue,
            ),
            iconSize: 48.0,
            onPressed: () => _toggleParsing(context, model),
          ),
          ..._traitComponents(context, model),
        ],
      ),
    );
  }

  List<Widget> _traitComponents(BuildContext context, CompositeTrait model) {
    return _hasTraits(model)
        ? [
            Divider(),
            Flexible(
              child: ListView.builder(
                itemCount: model.traits.length,
                itemBuilder: (context, index) => _TraitCard(index),
              ),
            )
          ]
        : [];
  }

  bool _hasTraits(CompositeTrait model) =>
      model.traits != null && model.traits.isNotEmpty;

  _toggleParsing(BuildContext context, CompositeTrait model) {
    ModelBinding.update(
        context, CompositeTrait.copyWithText(model, isParsed: !model.isParsed));
  }
}

class _TraitTextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CompositeTrait model = ModelBinding.of(context);
    final parsedText = model.parsedText;
    final TextEditingController controller =
        TextEditingController(text: parsedText);
    return buildTextField(controller: controller, enabled: false);
  }
}

class _TraitCard extends StatelessWidget {
  final int index;

  _TraitCard(this.index);

  @override
  Widget build(BuildContext context) {
    final CompositeTrait model = ModelBinding.of(context);
    final focused = !model.isParsed;
    final trait = model.traits[index];
    final detail =
        '${trait.reference ?? ""} ${trait.specialization ?? ""} [${trait.baseCost ?? 0}]';

    return Card(
      shape: _selectBorder(context, focused),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(trait.name ?? ''),
            subtitle: Text(detail),
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
              if (!model.isParsed)
                IconButton(
                  onPressed: () {
                    _addEnhancement(model, trait);
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                  ),
                ),
              Divider(),
            ],
          ),
          ...?_buildAllModifierWidgets(context, trait, focused),
        ],
      ),
    );
  }

  ShapeBorder _selectBorder(BuildContext context, bool focused) =>
      focused ? focusedBorder : Theme.of(context).cardTheme.shape;

  List<Widget> _buildAllModifierWidgets(
      BuildContext context, Trait trait, bool focused) {
    return trait.modifiers
        .map((it) => ModifierListTile(trait: trait, modifier: it))
        .toList();
  }

  void _addEnhancement(CompositeTrait model, Trait trait) {
    // display add enhancement dialog
  }
}

class ModifierListTile extends StatelessWidget {
  const ModifierListTile({
    Key key,
    @required this.trait,
    @required this.modifier,
  }) : super(key: key);

  final Trait trait;
  final ModifierComponents modifier;

  @override
  Widget build(BuildContext context) {
    final CompositeTrait model = ModelBinding.of(context);
    final focused = !model.isParsed;

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
            ModelBinding.update(
              context,
              CompositeTrait.remove(model, trait: trait, modifier: modifier),
            );
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
