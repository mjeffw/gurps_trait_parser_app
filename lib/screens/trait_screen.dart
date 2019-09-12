import 'package:flutter/material.dart';
import 'package:gurps_trait_parser_app/theme.dart';
import 'package:gurps_traits/gurps_traits.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../model/trait_text.dart';

class TraitScreen extends StatelessWidget {
  static const String id = "trait_screen";

  @override
  Widget build(BuildContext context) {
    final TraitModel model = ModelBinding.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        children: [
          IndexedStack(
            index: model.isParsed ? 1 : 0,
            children: [
              _TraitTextView(),
              _TraitTextEditor(trait: model),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.swap_vertical_circle,
              color: Colors.green,
            ),
            iconSize: 48.0,
            onPressed: () => _toggleParsing(context, model),
          ),
          ..._traitComponents(context, model),
        ],
      ),
    );
  }

  List<Widget> _traitComponents(BuildContext context, TraitModel model) {
    return _hasTraits(model)
        ? [
            Divider(),
            Flexible(
              child: ListView.builder(
                itemCount: model.traits.length,
                itemBuilder: (context, index) =>
                    _TraitCard(model.traits[index], !model.isParsed),
              ),
            )
          ]
        : [];
  }

  bool _hasTraits(TraitModel model) =>
      model.traits != null && model.traits.isNotEmpty;

  _toggleParsing(BuildContext context, TraitModel model) {
    var traitModel = TraitModel.toggleParsing(model, isParsed: !model.isParsed);
    ModelBinding.update(context, traitModel);
  }
}

class _TraitTextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TraitModel model = ModelBinding.of(context);
    final TextEditingController controller =
        TextEditingController(text: model.parsedText);
    return buildTextField(controller: controller, enabled: false);
  }
}

///
/// TraitForm
///
class _TraitTextEditor extends StatefulWidget {
  final TraitModel trait;

  _TraitTextEditor({Key key, @required this.trait}) : super(key: key);

  @override
  _TraitTextEditorState createState() => _TraitTextEditorState();
}

///
/// State.
///
class _TraitTextEditorState extends State<_TraitTextEditor> {
  TextEditingController _textController = TextEditingController();

  _TraitTextEditorState();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textController.text = widget.trait.rawText;
    _textController.addListener(_handleUpdate);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    ModelBinding.update(context,
        TraitModel.replaceText(widget.trait, text: _textController.text));
  }

  void _handleUpdate() {
    var traitModel =
        TraitModel.replaceText(widget.trait, text: _textController.text);
    ModelBinding.update(context, traitModel);

    if (_textController.text != traitModel.rawText && traitModel.isParsed) {
      _textController.text = traitModel.rawText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildTextField(controller: _textController, enabled: true);
  }
}

TextField buildTextField({TextEditingController controller, bool enabled}) {
  return TextField(
    enabled: enabled,
    maxLines: 5,
    controller: controller,
    decoration: InputDecoration(
        helperText: 'Use canonical form: Name {Level} (Parenthetical-Notes).',
        labelText: 'Trait Description'),
  );
}

class _TraitCard extends StatelessWidget {
  final Trait trait;
  final bool focused;

  _TraitCard(this.trait, this.focused);

  @override
  Widget build(BuildContext context) {
    var detail =
        '${trait.reference ?? ""} ${trait.specialization ?? ""} [${trait.baseCost ?? 0}]';

    return Card(
      shape: _selectBorder(context),
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
          Divider(),
          ...?_buildAllModifierWidgets(context),
        ],
      ),
    );
  }

  ShapeBorder _selectBorder(BuildContext context) =>
      focused ? focusedBorder : Theme.of(context).cardTheme.shape;

  List<Widget> _buildAllModifierWidgets(BuildContext context) {
    return trait.modifiers.map((it) => buildListTile(context, it)).toList();
  }

  Widget buildListTile(BuildContext context, ModifierComponents it) {
    var data =
        '${it.detail == it.name ? "" : it.detail + ", "}${it.value < 0 ? it.value : "+" + it.value.toString()}%';

    return Slidable(
      actionExtentRatio: 0.2,
      delegate: SlidableStrechDelegate(),
      child: ListTile(
        dense: true,
        title: Text(it.name),
        subtitle: Text(data),
        trailing: _MoreButton(),
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
          onTap: () => _showSnackBar(context, 'Share'),
        ),
      ],
    );
  }

  _showSnackBar(BuildContext context, String s) {
    SnackBar snackBar = SnackBar(content: Text(s));
    Scaffold.of(context).showSnackBar(snackBar);
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
        Slidable.of(context).open();
      },
    );
  }
}
