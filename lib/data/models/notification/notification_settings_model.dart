class NotificationSettingsModel {

  final bool pushNotifications;
  final bool donations;

  final bool rewardsAndPerks;

  NotificationSettingsModel({
    required this.pushNotifications,
    required this.donations,
    required this.rewardsAndPerks
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json){
    return NotificationSettingsModel(
        pushNotifications: json['pushNotifications'],
        donations: json['donations'],
        rewardsAndPerks: json['rewardsAndPerks']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pushNotifications": pushNotifications,
      "donations": donations,
      "rewardsAndPerks": rewardsAndPerks
    };
  }
}