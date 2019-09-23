import 'package:flutter/material.dart';

import '../model/trait_text.dart';

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

// TODO make TextEditingController the 'single source of truth' when parsing,
// TODO make CompositeTrait.rawText the 'SSOT' when editing with widgets.

///
/// TraitForm
///
class TraitTextEditor extends StatefulWidget {
  final CompositeTrait trait;

  TraitTextEditor({Key key, @required this.trait}) : super(key: key);

  @override
  _TraitTextEditorState createState() => _TraitTextEditorState();
}

///
/// State.
///
class _TraitTextEditorState extends State<TraitTextEditor> {
  TextEditingController _textController = TextEditingController();

  _TraitTextEditorState();

  @override
  Widget build(BuildContext context) {
    return buildTextField(controller: _textController, enabled: true);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    TraitTextEditor oldEditor = oldWidget as TraitTextEditor;
    if (oldEditor.trait.isParsed != widget.trait.isParsed) {
      _textController.text = widget.trait.rawText;
    }
    // ModelBinding.update(context,
    //     CompositeTrait.copyWithText(widget.trait, text: _textController.text));
  }

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

  void _handleUpdate() {
    var traitModel =
        CompositeTrait.copyWithText(widget.trait, text: _textController.text);
    ModelBinding.update(context, traitModel);

    if (_textController.text != traitModel.rawText && traitModel.isParsed) {
      _textController.text = traitModel.rawText;
    }
  }
}
