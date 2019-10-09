import 'package:flutter/material.dart';
import './custom_flat_button.dart';
import '../models/exercise.dart';
import '../models/exercise_request.dart';
class AllExercises extends StatefulWidget {

  AllExercises();

  @override
  State<StatefulWidget> createState() {
    return new _AllExercisesState();
  }
}

class _AllExercisesState extends State<AllExercises> {
  List<String> addedExercises = [];
  List<Exercise> allExercises;

  @override
  void initState() {
    super.initState();
    populateExerciseList();
  }
  
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.5)),
      child: ListView(
        children: <Widget>[
          ...fields(this.allExercises),
          CustomFlatButton(labelTitle: 'Done', onTap: () => {Navigator.of(context).pop(addedExercises)},)
        ],
      ),
    );
  }

  void populateExerciseList() async {
    var exerciseResponse = await ExerciseRequest.fetchAllExercises();
    setState(() {
     allExercises = exerciseResponse.data;
    });
  }

  void selectAction(Exercise item) {
    setState(() {
      addedExercises.add(item.sId);
      allExercises.remove(item);
    });
  }

  List<Widget> fields(List<Exercise> exercisesList) {
    return exercisesList == null ? [CircularProgressIndicator()] : exercisesList.map((item) => CustomFlatButton(labelTitle: item.name, onTap: () => {this.selectAction(item)},)).toList();
  }
}