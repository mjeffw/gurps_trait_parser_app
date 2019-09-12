import 'package:flutter/material.dart';

import 'model/trait_text.dart';
import 'screens/trait_screen.dart';
import 'theme.dart' as theme;

void main() => runApp(TraitParserApp());

class TraitParserApp extends StatelessWidget {
  TraitModel model = TraitModel(
      text:
          'Affliction 1 (Will; Based on Will, +20%; Disadvantage, Berserk, +10%; Fixed Duration, +0%; Malediction 2, +150%; No Signature, +20%; Runecasting, −30%) [27].');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme.gurpsTheme,
      title: 'GURPS Trait Parser',
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Trait Parser'),
          ),
          body: ModelBinding<TraitModel>(
            initialModel: model,
            child: TraitScreen(),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(
              height: 50.0,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment Counter',
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
