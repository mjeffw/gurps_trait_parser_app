import 'package:flutter_web/material.dart';

import 'model/trait_text.dart';
import 'screens/trait_screen.dart';
import 'theme.dart' as theme;

void main() => runApp(TraitParserApp());

class TraitParserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme.gurpsTheme,
      title: 'GURPS Trait Parser',
      home: ModelBinding<TraitModel>(
        initialModel: TraitModel(),
        child: SafeArea(
          child: Scaffold(
            body: TraitScreen(),
          ),
        ),
      ),
    );
  }
}
