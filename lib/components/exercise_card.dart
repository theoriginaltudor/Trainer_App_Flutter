import 'package:flutter/material.dart';
import '../components/custom_flat_button.dart';
import '../components/custom_text_field.dart';
import '../models/history.dart';
import '../models/history_request.dart';


class ExerciseCard extends StatefulWidget {
  final String workoutId;
  final String exerciseId;
  final String recomendation;

  ExerciseCard({this.workoutId, this.exerciseId, this.recomendation});

  @override
  State<StatefulWidget> createState() {
    return new _ExerciseCardState();
  }
}

class _ExerciseCardState extends State<ExerciseCard> {
  // history ar trebui sa fie un fetch
  List<History> history;
  List<String> inputData = [];

  @override
  void initState() {
    super.initState();
    _populateHistoryList();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: this.history == null ? CircularProgressIndicator() : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('PushUps', textAlign: TextAlign.center),
          Text(this.widget.recomendation),
          ...fields(this.history),
          CustomFlatButton(labelTitle: 'Add set',onTap: () => {addSet()})
        ],
      ),
    );
  }

  void _populateHistoryList() async {
    var response = await HistoryRequest.fetchHistory(widget.exerciseId, widget.workoutId);
    // print(response.data.toString());
    setState(() {
      history = response.data;
      for (var item in response.data) {
        inputData.add('');
      }
    });
  }

  void addSet() {
    // setState(() {
    //  history.add('15kg x 20');
    //  inputData.add('');
    // });
  }

  void fillPrevious(index) {
    String previous = history[index].kg.numberDecimal + history[index].repetitions.toString();
    setState(() {
     inputData[index] = previous;
    });
  }

  List<Widget> fields(List<History> history) {
    print('printing history' + history.first.toString());
    return history.asMap().map((index, entry) => MapEntry(index, Row(
      children: <Widget>[
        Expanded(
          child: CustomFlatButton(labelTitle:(entry.kg.numberDecimal + 'kg x' + entry.repetitions.toString()), onTap: () => {
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
