class Workout {
  List<String> exerciseList;
  List<String> recomendationsList;
  String sId;
  String name;
  String clientId;

  Workout({
    this.exerciseList,
    this.recomendationsList,
    this.sId,
    this.name,
    this.clientId,
  });

  Workout.fromJson(Map<String, dynamic> json) {
    exerciseList = json['exerciseList'].cast<String>();
    recomendationsList = json['recomendationsList'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exerciseList'] = this.exerciseList;
    data['recomendationsList'] = this.recomendationsList;
    // data['_id'] = this.sId;
    data['name'] = this.name;
    data['clientId'] = this.clientId;
    return data;
  }
}
