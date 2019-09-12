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
    print('TraitScreen.build');
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _TraitText(trait: model),
          IconButton(
            icon: Icon(
              Icons.swap_vertical_circle,
              color: Colors.green,
            ),
            iconSize: 48.0,
            onPressed: () => _toggleParsing(context, model),
          ),
          if (_hasTraits(model)) Divider(),
          if (_hasTraits(model))
            Flexible(
              child: ListView.builder(
                  itemCount: model.traits.length,
                  itemBuilder: (context, index) =>
                      _TraitCard(model.traits[index], !model.isParsed)),
            ),
        ],
      ),
    );
  }

  bool _hasTraits(TraitModel model) =>
      model.traits != null && model.traits.isNotEmpty;

  _toggleParsing(BuildContext context, TraitModel model) {
    var traitModel = TraitModel.toggleParsing(model, isParsed: !model.isParsed);
    ModelBinding.update(context, traitModel);
  }
}

///
/// TraitForm
///
class _TraitText extends StatefulWidget {
  final TraitModel trait;

  _TraitText({Key key, @required this.trait}) : super(key: key) {
    print('create _TraitText');
  }

  @override
  _TraitTextState createState() => _TraitTextState();
}

///
/// State.
///
class _TraitTextState extends State<_TraitText> {
  TextEditingController _textController = TextEditingController();

  _TraitTextState();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('_TraitTextState.initState');
    super.initState();

    _textController.text = widget.trait.text;
    _textController.addListener(_handleUpdate);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    print('_TraitTextState.didUpdateWidget');
    super.didUpdateWidget(oldWidget);
    var traitModel =
        TraitModel.replaceText(widget.trait, text: _textController.text);
    ModelBinding.update(context, traitModel);
  }

  void _handleUpdate() {
    print('_TraitTextState.handleUpdate');
    var traitModel =
        TraitModel.replaceText(widget.trait, text: _textController.text);
    ModelBinding.update(context, traitModel);

    if (_textController.text != traitModel.text) {
      _textController.text = traitModel.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_TraitTextState.build');
    return TextField(
      enabled: widget.trait.isParsed,
      maxLines: 5,
      controller: _textController,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          helperText: 'Use canonical form: Name {Level} (Parenthetical-Notes).',
          labelText: 'Trait Description'),
    );
  }
}

class _TraitCard extends StatelessWidget {
  final Trait trait;
  final bool focused;

  _TraitCard(this.trait, this.focused);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      shape: focused ? focusedBorder : Theme.of(context).cardTheme.shape,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(trait.name ?? ''),
            subtitle: Text(
                '${trait.reference ?? ""} ${trait.specialization ?? ""} [${trait.baseCost ?? 0}]'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
