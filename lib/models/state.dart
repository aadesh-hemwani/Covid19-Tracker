
class StateModel {
  String state;
  String active;
  String confirmed;
  String deaths;
  String deltaconfirmed;
  String deltadeaths;
  String deltarecovered;
  String recovered;
  String statenotes;

  StateModel({

    this.state,
    this.active,
    this.confirmed,
    this.deaths,
    this.deltaconfirmed,
    this.deltadeaths,
    this.deltarecovered,
    this.recovered,
    this.statenotes,
  });

  factory StateModel.fromJson(Map<String, dynamic> json){
    return StateModel(
        state: json["state"],
        active: json["active"],
        confirmed: json["confirmed"],
        deaths: json["deaths"],
        deltaconfirmed: json["deltaconfirmed"],
        deltadeaths: json["deltadeaths"],
        deltarecovered: json["deltarecovered"],
        recovered: json["recovered"],
        statenotes: json["statenotes"]
    );
  }
}