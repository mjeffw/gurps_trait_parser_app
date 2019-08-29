import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';
import 'package:gurps_traits/gurps_traits.dart';

import '../model/trait_text.dart';
import '../theme.dart' as theme;

class TraitScreen extends StatelessWidget {
  static const String id = "trait_screen";

  @override
  Widget build(BuildContext context) {
    final TraitModel model = ModelBinding.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trait', style: theme.titleStyle),
        _TraitText(trait: model),
        if (model.traits != null && model.traits.isNotEmpty) _ComponentList()
      ],
    );
  }
}

///
/// TraitForm
///
class _TraitText extends StatefulWidget {
  final TraitModel trait;

  _TraitText({Key key, @required this.trait}) : super(key: key);

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
    super.initState();
    _textController.text = widget.trait.text;
    _textController.addListener(_handleUpdate);
  }

  void _handleUpdate() {
    var traitModel =
        TraitModel.replaceText(widget.trait, text: _textController.text);
    ModelBinding.update(context, traitModel);

    if (_textController.text != traitModel.text) {
      _textController.text = traitModel.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 5,
      controller: _textController,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          helperText:
              'A trait description in canonical GURPS format: Name {Level} (Parenthetical-Notes)',
          labelText: 'Trait Description'),
    );
  }
}

class _ComponentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TraitModel model = ModelBinding.of(context);
    final List<Trait> components = model.traits;
    return Column(
      children: <Widget>[
        Divider(),
        ...?components.where((v) => v != null).map((it) => _TraitCard(it)),
      ],
    );
  }
}

class _TraitCard extends StatelessWidget {
  final Trait trait;

  _TraitCard(this.trait);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(trait.description ?? ''),
            subtitle: Text(
                '${trait.reference ?? ""} ${trait.specialization ?? ""} [${trait.baseCost ?? 0}]'),
            isThreeLine: false,
          ),
          Divider(),
          ...?trait.modifiers.map(
            (it) => ListTile(
              dense: true,
              title: Text(it.name),
              subtitle: Text(it.detail == it.name ? "" : it.detail),
              trailing: Text(
                  '${it.value < 0 ? it.value : "+" + it.value.toString()}%'),
            ),
          ),
          Divider(),
          Text('Total cost: ${trait.cost}')
        ],
      ),
    );
  }
}
