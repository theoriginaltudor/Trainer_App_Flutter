class History {
  String sId;
  Kg kg;
  int repetitions;
  int repetitionsInReserve;
  String date;
  String exerciseId;
  String workoutId;
  String clientId;

  History(
      {this.sId,
      this.kg,
      this.repetitions,
      this.repetitionsInReserve,
      this.date,
      this.exerciseId,
      this.workoutId,
      this.clientId});

  History.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    kg = json['kg'] != null ? new Kg.fromJson(json['kg']) : null;
    repetitions = json['repetitions'];
    repetitionsInReserve = json['repetitionsInReserve'];
    date = json['date'];
    exerciseId = json['exerciseId'];
    workoutId = json['workoutId'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.kg != null) {
      data['kg'] = this.kg.toJson();
    }
    data['repetitions'] = this.repetitions;
    data['repetitionsInReserve'] = this.repetitionsInReserve;
    data['date'] = this.date;
    data['exerciseId'] = this.exerciseId;
    data['workoutId'] = this.workoutId;
    data['clientId'] = this.clientId;
    return data;
  }
}

class Kg {
  String numberDecimal;

  Kg({this.numberDecimal});

  Kg.fromJson(Map<String, dynamic> json) {
    numberDecimal = json['$numberDecimal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$numberDecimal'] = this.numberDecimal;
    return data;
  }
}