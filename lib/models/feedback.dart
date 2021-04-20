class FeedbackModel{
  String stationName;
  String diesel;
  String unleaded;
  String kerosene;
  String oil;

  FeedbackModel({
      this.stationName,
      this.diesel,
      this.kerosene,
      this.oil,
      this.unleaded,
      });

  factory FeedbackModel.fromJson(dynamic json){
    return FeedbackModel(
      stationName: "${json['stationName']}",
      diesel: "${json['diesel']}",
      unleaded: "${json['super']}",
      kerosene: "${json['kerosene']}",
      oil: "${json['oil']}",
    );
  }

  Map toJson() => {
    'stationName': stationName,
    'diesel': diesel,
    'super': unleaded,
    'kerosene': kerosene,
    'oil': oil,
  };

}