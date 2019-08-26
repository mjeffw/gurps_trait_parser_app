import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

import '../model/trait_text.dart';

class TraitScreen extends StatelessWidget {
  static const String id = "trait_screen";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TraitScreen(),
        ],
      ),
    );
  }
}

class _TraitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TraitModel trait = ModelBinding.of(context);
    print('_TraitScreen.build');
    return TraitForm(trait: trait);
  }
}

///
/// TraitForm
///
class TraitForm extends StatefulWidget {
  final TraitModel trait;

  TraitForm({Key key, @required this.trait}) : super(key: key);

  @override
  _TraitFormState createState() => _TraitFormState();
}

///
/// State.
///
class _TraitFormState extends State<TraitForm> {
  TextEditingController _textController = TextEditingController();

  _TraitFormState() {
    print('_TraitFormState');
  }

  @override
  void dispose() {
    _textController.dispose();
    print('dispose');
    super.dispose();
  }

  @override
  void initState() {
    print('initState');
    super.initState();
    _textController.text = widget.trait.text;
    _textController.addListener(_handleUpdate);
  }

  // @override
  // void didUpdateWidget(TraitForm oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (_textController.text != widget.trait.text) {
  //     print('didUpdateWidget: ${widget.trait.text}');
  //     _textController.text = widget.trait.text;
  //   }
  // }

  void _handleUpdate() {
    var traitModel =
        TraitModel.replaceText(widget.trait, text: _textController.text);
    ModelBinding.update(context, traitModel);
    if (_textController.text != traitModel.text) {
      print('changed: [${_textController.text}] to [${traitModel.text}]');
      _textController.text = traitModel.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
        ));

    return TextField(
      maxLines: 5,
      decoration: inputDecoration,
      controller: _textController,
      // onChanged: (text) {
      //   print('changed:  ${_textController.text}');
      //   var traitModel = TraitModel.replaceText(widget.trait, text: text);
      //   ModelBinding.update(context, traitModel);
      //   setState(() {
      //     _textController.text = traitModel.text;
      //   });
      // },
    );
  }
}
