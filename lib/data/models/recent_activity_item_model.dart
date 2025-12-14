class RecentActivityItemModel {
  final String id;
  final String type;
  final DateTime? timestamp;
  final String rewardTitle;
  final String? userName;
  final String? userImage;
  final String? assignedCode;
  final String? qrCode;
  final String? redemptionMethod;
  final String timeAgo;

  RecentActivityItemModel({
    required this.id,
    required this.type,
    this.timestamp,
    required this.rewardTitle,
    this.userName,
    this.userImage,
    this.assignedCode,
    this.qrCode,
    this.redemptionMethod,
    required this.timeAgo,
  });

  factory RecentActivityItemModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityItemModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
      rewardTitle: json['rewardTitle'] ?? '',
      userName: json['userName'],
      userImage: json['userImage'],
      assignedCode: json['assignedCode'],
      qrCode: json['qrCode'],
      redemptionMethod: json['redemptionMethod'],
      timeAgo: json['timeAgo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'timestamp': timestamp?.toIso8601String(),
      'rewardTitle': rewardTitle,
      'userName': userName,
      'userImage': userImage,
      'assignedCode': assignedCode,
      'qrCode': qrCode,
      'redemptionMethod': redemptionMethod,
      'timeAgo': timeAgo,
    };
  }
}