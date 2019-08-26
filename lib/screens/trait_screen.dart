import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

import '../model/trait_text.dart';

class TraitScreen extends StatelessWidget {
  static const String id = "trait_screen";

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      model: TraitModel(),
      child: _TraitScreen(),
    );
  }
}

class _TraitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TraitModel trait = TraitModel.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('GURPS Trait Parser'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TraitForm(trait: trait),
          ],
        ),
      ),
    );
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

  // _TraitFormState();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('initState');
    super.initState();
    setState(() {
      _textController.text = widget.trait.text;
    });
  }

  @override
  void didUpdateWidget(TraitForm oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
    _textController.text = widget.trait.text;
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
      onChanged: (text) {
        TraitModel.update(
            context, TraitModel.replaceText(widget.trait, text: text));
      },
    );
  }
}
