import 'package:flutter_web/material.dart';

import 'model/trait_text.dart';
import 'screens/trait_screen.dart';

void main() {
  runApp(TraitParserApp());
}

class TraitParserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      title: 'GURPS Trait Parser',
      home: ModelBinding<TraitModel>(
          initialModel: TraitModel(),
          child: Scaffold(
            body: TraitScreen(),
          )),
    );
  }
}
