import 'package:flutter_web/material.dart';
import 'package:gurps_traits/gurps_traits.dart';

import '../model/trait_text.dart';

class TraitScreen extends StatelessWidget {
  static const String id = "trait_screen";

  @override
  Widget build(BuildContext context) {
    final TraitModel model = ModelBinding.of(context);

    if (_hasTraits(model)) {
      print(model.traits.length);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(''),
        _TraitText(trait: model),
        if (_hasTraits(model)) Divider(),
        if (_hasTraits(model))
          Flexible(
            child: ListView.builder(
                itemCount: model.traits.length,
                itemBuilder: (context, index) =>
                    _TraitCard(model.traits[index])),
          ),
      ],
    );
  }

  bool _hasTraits(TraitModel model) =>
      model.traits != null && model.traits.isNotEmpty;
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
              'A trait in canonical format: Name {Level} (Parenthetical-Notes)',
          labelText: 'Trait Description'),
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
