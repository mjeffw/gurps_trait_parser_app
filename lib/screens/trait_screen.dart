import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

import '../model/trait_text.dart';
import '../theme.dart' as theme;

class TraitScreen extends StatelessWidget {
  static const String id = "trait_screen";

  @override
  Widget build(BuildContext context) {
    final TraitModel trait = ModelBinding.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trait',
          style: theme.titleStyle,
        ),
        _TraitText(trait: trait),
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
