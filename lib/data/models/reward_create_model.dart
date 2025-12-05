class RewardCreateModel {
  final String businessId;
  final String? title;
  final String? description;
  final String? type;
  final String? category;
  int redemptionLimit;
  final DateTime startDate;
  final DateTime expiryDate;
  final InStoreRedemptionMethods inStoreRedemptionMethods;
  final dynamic onlineRedemptionMethods;
  final bool featured;

  RewardCreateModel({
    required this.businessId,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.redemptionLimit,
    required this.startDate,
    required this.expiryDate,
    required this.inStoreRedemptionMethods,
    required this.onlineRedemptionMethods,
    required this.featured,
  });

  factory RewardCreateModel.fromJson(Map<String, dynamic> json) {
    return RewardCreateModel(
      businessId: json['businessId'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      category: json['category'],
      redemptionLimit: json['redemptionLimit'],
      startDate: DateTime.parse(json['startDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      inStoreRedemptionMethods: InStoreRedemptionMethods.fromJson(
        json['inStoreRedemptionMethods'],
      ),
      onlineRedemptionMethods: json['onlineRedemptionMethods'],
      featured: json['featured'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "businessId": businessId,
      "title": title,
      "description": description,
      "type": type,
      "category": category,
      "redemptionLimit": redemptionLimit,
      "startDate": startDate.toUtc().toIso8601String(),
      "expiryDate": expiryDate.toUtc().toIso8601String(),
      "inStoreRedemptionMethods": inStoreRedemptionMethods.toJson(),
      "onlineRedemptionMethods": onlineRedemptionMethods,
      "featured": featured,
    };
  }
}

class InStoreRedemptionMethods {
  final bool qrCode;
  final bool staticCode;
  final bool nfcTap;

  InStoreRedemptionMethods({
    required this.qrCode,
    required this.staticCode,
    required this.nfcTap,
  });

  factory InStoreRedemptionMethods.fromJson(Map<String, dynamic> json) {
    return InStoreRedemptionMethods(
      qrCode: json['qrCode'],
      staticCode: json['staticCode'],
      nfcTap: json['nfcTap'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "qrCode": qrCode,
      "staticCode": staticCode,
      "nfcTap": nfcTap,
    };
  }
}
