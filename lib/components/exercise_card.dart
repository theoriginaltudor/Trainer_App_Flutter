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

  void saveData({String workoutId = ''}) => state.saveHistoryEntry(workoutId);
}

class _ExerciseCardState extends State<ExerciseCard> {
  List<History> history;
  List<TextEditingController> kgInputData = [];
  List<TextEditingController> repsInputData = [];
  String exerciseName;
  List<List<History>> historyBySet;

  @override
  void initState() {
    super.initState();
    populateHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: this.history == null
          ? CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(this.exerciseName, textAlign: TextAlign.center),
                Text(this.widget.recomendation),
                ...fields(this.historyBySet),
                CustomFlatButton(labelTitle: 'Add set', onTap: addSet),
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

  void saveHistoryEntry(String workoutId) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day, 2);

    for (var i = 0; i < this.kgInputData.length; i++) {
      HistoryRequest.postHistoryEntry(
          workoutId == '' ? widget.workoutId : workoutId,
          widget.exerciseId,
          new History(
            kg: new Kg(numberDecimal: this.kgInputData[i].text),
            repetitions: int.tryParse(this.repsInputData[i].text),
            repetitionsInReserve: 2,
            date: today.toIso8601String(),
            setNo: i + 1,
          ));
    }
  }

  void populateHistoryList() async {
    var historyResponse;
    if (widget.workoutId == null) {
      historyResponse = <History>[];
    } else {
      historyResponse =
          (await HistoryRequest.fetchHistoryExercise(widget.exerciseId)).data;
    }
    var exerciseResponse =
        (await ExerciseRequest.fetchExercise(widget.exerciseId)).data;
    setState(() {
      //TODO this is null when running offline
      exerciseName = exerciseResponse.first.name;
      history = historyResponse;
      historyBySet = processHistoryList(historyResponse);
      if (historyBySet != null) {
        for (var item in historyBySet) {
          kgInputData.add(TextEditingController());
          repsInputData.add(TextEditingController());
        }
      }
    });
  }

  List<List<History>> processHistoryList(List<History> list) {
    if (list.length == 0) {
      return null;
    }
    List<List<History>> newList = [];
    List<int> sets = [];
    for (var item in list) {
      sets.add(item.setNo);
    }
    List<int> distinctSets = sets.toSet().toList();
    for (var item in distinctSets) {
      List<History> tempList = [];
      for (var entry in list) {
        if (item == entry.setNo) {
          tempList.add(entry);
        }
      }
      newList.add(tempList);
    }
    // print('processed list ' + jsonEncode(newList));s
    return newList;
  }

  void addSet() {
    setState(() {
      history.add(new History(kg: new Kg()));
      kgInputData.add(TextEditingController());
      repsInputData.add(TextEditingController());
      if (historyBySet == null) {
        historyBySet = [
          [history.last]
        ];
      } else {
        historyBySet.add([history.last]);
      }
    });
  }

  void fillPrevious(int index, History item) {
    setState(() {
      kgInputData[index].text = item.kg.numberDecimal;
      repsInputData[index].text = item.repetitions.toString();
    });
  }

  List<Widget> fields(List<List<History>> historyLists) {
    if (historyLists == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => addSet());
      return [CircularProgressIndicator()];
    } else {
      return historyLists
          .asMap()
          .map((index, entry) => MapEntry(
                index,
                Dismissible(
                  background: Container(color: Colors.red),
                  key: Key(entry.hashCode.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      historyBySet.remove(entry);
                      for (var item in entry) {
                        history.remove(item);
                      }
                      kgInputData.removeAt(index);
                      repsInputData.removeAt(index);
                    });

                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Dismissed')));
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // TODO: show history even if is a new set
                          child: entry.first.sId == null
                              ? CustomFlatButton(
                                  labelTitle: 'No history',
                                  horizontalPadding: 0.0,
                                  onTap: () => print('No data'),
                                )
                              : CarouselSlider(
                                  height: 60.0,
                                  items: carouselItems(entry, index),
                                  initialPage: entry.length,
                                  enableInfiniteScroll: false)),
                      Expanded(
                        child: CustomTextField(controller: kgInputData[index]),
                      ),
                      Expanded(
                        child:
                            CustomTextField(controller: repsInputData[index]),
                      )
                    ],
                  ),
                ),
              ))
          .values
          .toList();
    }
  }

  List<Widget> carouselItems(List<History> entry, int index) {
    List<Widget> itemList = entry
        .map((item) => CustomFlatButton(
              labelTitle: (item.kg.numberDecimal +
                  'kg x' +
                  item.repetitions.toString()),
              horizontalPadding: 0.0,
              onTap: () => fillPrevious(index, item),
            ))
        .toList();
    return itemList;
  }
}
