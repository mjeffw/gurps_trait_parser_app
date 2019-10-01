import 'package:flutter/material.dart';
import 'package:gurps_trait_parser_app/theme.dart';
import 'package:gurps_trait_parser_app/util/widget_util.dart';

class AddModifierWidget extends StatelessWidget {
  const AddModifierWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      elevation: 0.0,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[400],
                  offset: const Offset(0.0, 0.0),
                ),
                BoxShadow(
                  color: Colors.grey[100],
                  offset: const Offset(0.0, 0.0),
                  spreadRadius: -0.5,
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Text('Add Modifier',
                    style: smallLabelStyle.apply(fontSizeFactor: 1.5)),
                Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  child: Row(children: [
                    Flexible(
                        flex: 40,
                        child: buildTextField(maxLines: 1, labelText: 'Name')),
                    Spacer(),
                    Flexible(
                        flex: 10,
                        child:
                            buildTextField(maxLines: 1, labelText: '% Value'))
                  ]),
                ),
                buildTextField(maxLines: 1, labelText: 'Description'),
                ButtonBar(
                  children: [
                    FlatButton(child: Text('APPLY'), onPressed: () {}),
                    FlatButton(child: Text('CANCEL'), onPressed: () {})
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
