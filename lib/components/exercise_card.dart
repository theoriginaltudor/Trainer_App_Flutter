import 'package:flutter/material.dart';
import 'package:trainer_app_flutter/components/custom_flat_button.dart';
import 'package:trainer_app_flutter/components/custom_text_field.dart';

class ExerciseCard extends StatefulWidget {
  final String heading;
  final String body;
  final Function onTap;

  ExerciseCard({this.heading, this.body, this.onTap});

  @override
  State<StatefulWidget> createState() {
    return new _ExerciseCardState();
  }
}

class _ExerciseCardState extends State<ExerciseCard> {
  List<String> history = ['15kg x 20'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('PushUps', textAlign: TextAlign.center,),
          Text('2x10-20RIR2'),
          ...fields(this.history),
          CustomFlatButton(labelTitle: 'Add set',onTap: () => {addSet()},)
        ],
      ),
    );
  }

  void addSet() {
    setState(() {
     history.add('15kg x 20'); 
    });
  }

  List<Widget> fields(List<String> history) {
    return history.map((entry) => Row(
      children: <Widget>[
        Expanded(
          child: CustomFlatButton(labelTitle: entry,)
        ),
        Expanded(
          child: CustomTextField(labelTitle: '',),
        ),
        Expanded(
          child: CustomTextField(labelTitle: '',),
        )
        
      ],
    )).toList();
  }
}
