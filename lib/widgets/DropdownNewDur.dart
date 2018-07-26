import 'package:flutter/material.dart';

class DropdownNewDur extends StatelessWidget {

  final String title;
  final String hint;
  final Map<String, Duration> values;
  final Duration selected;
  final ValueChanged<Duration> onSelect;

  DropdownNewDur({ this.title, this.hint, this.values, this.selected, this.onSelect });

  @override
  Widget build(BuildContext context) {

    return new Column(

      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[

        new Padding(
          padding: new EdgeInsets.only( left: 20.0, top: 20.0 ),
          child: new Text( this.title, style: new TextStyle( fontSize: 16.0, color: Colors.grey ), ),
        ),

        new SizedBox(
            width: 1000.0,
            child: new DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: new DropdownButton<Duration>(
                  hint: Text( this.hint ),
                  items: this.values.map((String value, Duration dur) {
                    return new MapEntry(
                              value,
                              new DropdownMenuItem<Duration>(
                                value: dur,
                                child: new Text(value),
                              )
                            );
                  }).values.toList(),
                  value: this.selected,
                  style: new TextStyle( fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.bold ),
                  iconSize: 20.0,
                  onChanged: this.onSelect,
                ),
              ),
            )
        )

      ],
    );

  }

}