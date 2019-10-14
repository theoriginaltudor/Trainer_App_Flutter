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
  final state = _ExerciseCardState();
  ExerciseCard({this.workoutId, this.exerciseId, this.recomendation});

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  void saveData() => state.saveHistoryEntry();
}

class _ExerciseCardState extends State<ExerciseCard> {
  List<History> history;
  List<TextEditingController> kgInputData = [];
  List<TextEditingController> repsInputData = [];
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

  void dispose() {
    
    for (var controller in this.kgInputData) {
      controller.dispose();
    }
    for (var controller in this.repsInputData) {
      controller.dispose();
    }
    super.dispose();
  }

  void saveHistoryEntry() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    
    for (var i = 0; i < this.kgInputData.length; i++) {
      // var exId = widget.exerciseId;
      // print('$i for id $exId');
      HistoryRequest.postHistoryEntry(widget.workoutId, widget.exerciseId, new History(
        kg: new Kg(numberDecimal: this.kgInputData[i].text),
        repetitions: int.tryParse(this.repsInputData[i].text),
        repetitionsInReserve: 2,
        date: today.toIso8601String(),
        exerciseId: widget.exerciseId,
        workoutId: widget.workoutId
      ));
    }
  }

  void populateHistoryList() async {
    var historyResponse;
    if (widget.workoutId == null) {
      historyResponse = <History>[];
    } else {
      historyResponse = (await HistoryRequest.fetchHistoryExercise(widget.exerciseId, widget.workoutId)).data;
    }
    var exerciseResponse = (await ExerciseRequest.fetchExercise(widget.exerciseId)).data;
    setState(() {
      exerciseName = exerciseResponse.first.name;
      history = historyResponse;
      for (var item in historyResponse) {
        kgInputData.add(TextEditingController());
        repsInputData.add(TextEditingController());
      }
      historyByDate = processHistoryList(historyResponse);
    });
  }

  List<List<History>> processHistoryList(List<History> list) {
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
    return newList;
  }

  void addSet() {
    setState(() {
      history.add(new History(kg: new Kg()));
      kgInputData.add(TextEditingController());
      repsInputData.add(TextEditingController());
      if (historyByDate == null) {
        historyByDate = [[history.last]];
      } else {
        historyByDate.add([history.last]);
      }
    });
  }

  void fillPrevious(index) {
    kgInputData[index].text = history[index].kg.numberDecimal;
    repsInputData[index].text = history[index].repetitions.toString();
  }

  List<Widget> fields(List<List<History>> historyLists) {
    if (historyLists == null) {
      WidgetsBinding.instance
        .addPostFrameCallback((_) => addSet());
      return [
        CircularProgressIndicator()
      ];
    } else {
      return historyLists.asMap().map((index, entry) => MapEntry(index,
      Dismissible(
        background: Container(color: Colors.red),
        key: Key(entry.hashCode.toString()),
        onDismissed: (direction) {
          setState(() {
            historyByDate.remove(entry);
            for (var item in entry) {
              history.remove(item);
            }
          });

          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Dismissed')));
        },
        child: Row(
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
              child: CustomTextField(controller: kgInputData[index]),
            ),
            Expanded(
              child: CustomTextField(controller: repsInputData[index]),
            )
            
          ],
      )))).values.toList();
    }
  }

  List<Widget> carouselItems(List<History> entry, int index) {
    List<Widget> itemList = entry.map((i) => CustomFlatButton(labelTitle:(entry.first.kg.numberDecimal + 'kg x' + entry.first.repetitions.toString()), onTap: () => {fillPrevious(index)},)).toList();
    return itemList;
  }
}
