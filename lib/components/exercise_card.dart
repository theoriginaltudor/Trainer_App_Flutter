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
  List<String> inputData = [''];

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
     inputData.add('');
    });
  }

  void fillPrevious(index) {
    List<String> values = history[index].split('kg x ');
    String previous = values.toString().substring(1, values.toString().length - 1);
    setState(() {
     inputData[index] = previous;
    });
  }

  List<Widget> fields(List<String> history) {
    return history.asMap().map((index, entry) => MapEntry(index, Row(
      children: <Widget>[
        Expanded(
          child: CustomFlatButton(labelTitle: entry, onTap: () => {
            fillPrevious(index)
          },)
        ),
        Expanded(
          child: CustomTextField(labelTitle: inputData[index].split(',').length == 1 ? '' : inputData[index].split(',')[0]),
        ),
        Expanded(
          child: CustomTextField(labelTitle: inputData[index].split(',').length == 1 ? '' : inputData[index].split(',')[1]),
        )
        
      ],
    ))).values.toList();
  }
}
