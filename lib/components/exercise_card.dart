import 'package:flutter/material.dart';
import '../models/exercise_request.dart';
import '../components/custom_flat_button.dart';
import '../components/custom_text_field.dart';
import '../models/history.dart';
import '../models/history_request.dart';
import 'package:carousel_slider/carousel_slider.dart';


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
  List<History> history;
  List<String> inputData = [];
  String exerciseName;
  List<List<History>> historyByDate;

  @override
  void initState() {
    super.initState();
    populateHistoryList();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: this.history == null ? CircularProgressIndicator() : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(this.exerciseName, textAlign: TextAlign.center),
          Text(this.widget.recomendation),
          ...fields(this.historyByDate),
          CustomFlatButton(labelTitle: 'Add set',onTap: () => {addSet()})
        ],
      ),
    );
  }

  void populateHistoryList() async {
    var historyResponse = await HistoryRequest.fetchHistory(widget.exerciseId, widget.workoutId);
    var exerciseResponse = await ExerciseRequest.fetchExercise(widget.exerciseId);
    setState(() {
      exerciseName = exerciseResponse.data.first.name;
      history = historyResponse.data;
      for (var item in historyResponse.data) {
        inputData.add('');
      }
      historyByDate = processHistoryList(historyResponse.data);
    });
  }

  List<List<History>> processHistoryList(List<History> list) {
    print('should process the list ' + list.toString());
    if (list.length == 0) {
      return null;
    }
    List<List<History>> newList = [];
    List<String> dates = [];
    for (var item in list) {
      dates.add(item.date);
    }
    List<String> distinctDates = dates.toSet().toList();
    for (var item in distinctDates) {
      List<History> tempList = [];
      for (var entry in list) {
        if (item == entry.date) {
          tempList.add(entry);
        }
      }
      newList.add(tempList);
    }
    print(newList);
    return newList;
  }

  void addSet() {
    print('should add set');
    setState(() {
     history.add(new History(kg: new Kg()));
     inputData.add('');
     if (historyByDate == null) {
       historyByDate = [[history.last]];
     } else {
       historyByDate.add([history.last]);
     }
    });
  }

  void fillPrevious(index) {
    String previous = history[index].kg.numberDecimal + history[index].repetitions.toString();
    setState(() {
     inputData[index] = previous;
    });
  }

  List<Widget> fields(List<List<History>> history) {
    print('list of lists of history is '+ history.toString());
    if (history == null) {
      WidgetsBinding.instance
        .addPostFrameCallback((_) => addSet());
      return [
        CircularProgressIndicator()
      ];
    } else {
      return history.asMap().map((index, entry) => MapEntry(index, Row(
        children: <Widget>[
          Expanded(
            child: entry.first.sId == null ? CustomFlatButton(labelTitle: 'No history',onTap: ()=> {
              print('No data')
            },) : CarouselSlider(
              height: 150.0,
              items: carouselItems(entry, index),
              enableInfiniteScroll: false
            )
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

  List<Widget> carouselItems(List<History> entry, int index) {
    print(entry);
    List<Widget> itemList = entry.map((i) => CustomFlatButton(labelTitle:(entry.first.kg.numberDecimal + 'kg x' + entry.first.repetitions.toString()), onTap: () => {fillPrevious(index)},)).toList();
    print(itemList);
    return itemList;
  }
}
