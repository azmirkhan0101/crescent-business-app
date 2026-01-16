class OnlineRewardCreateModel {

  var a = {
    "businessId": "{{businessId}}",
    "title": "\$25 Gift Card",
    "description": "Redeem this \$25 gift card online or in-store.",
    "type": "online",
    "category": "other",
    "onlineRedemptionMethods": {
      "giftCard": true,
      "discountCode": true
    },
    "featured": false
  };


  var b = {
    "businessId": "{{businessId}}",
    "title": "\$25 Gift Card Online 2",
    "description": "Redeem this \$25 gift card online.",
    "type": "online",
    "category": "other",
    "redemptionLimit": 9,
    "onlineRedemptionMethods": {
      "giftCard": true,
      "discountCode": true
    },
    "featured": false,
    "startDate": "{{startDate}}",
    "expiryDate": "{{expiryDate}}"
  };


  final String businessId;
  final String? title;
  final String? description;
  final String? type;
  final String? category;
  final DateTime startDate;
  final DateTime expiryDate;
  final CreateOnlineRedemptionMethods onlineRedemptionMethods;
  final bool featured;

  OnlineRewardCreateModel({
    required this.businessId,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.startDate,
    required this.expiryDate,
    required this.onlineRedemptionMethods,
    required this.featured,
  });

  factory OnlineRewardCreateModel.fromJson(Map<String, dynamic> json) {
    return OnlineRewardCreateModel(
      businessId: json['businessId'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      category: json['category'],
      startDate: DateTime.parse(json['startDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      onlineRedemptionMethods: CreateOnlineRedemptionMethods.fromJson(
        json['onlineRedemptionMethods'],
      ),
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
      "startDate": startDate.toIso8601String(),
      "expiryDate": expiryDate.toIso8601String(),
      "onlineRedemptionMethods": onlineRedemptionMethods.toJson(),
      "featured": featured,
    };
  }
}

class CreateOnlineRedemptionMethods {
  final bool giftCard;
  final bool discountCode;

  CreateOnlineRedemptionMethods({required this.giftCard, required this.discountCode});
  factory CreateOnlineRedemptionMethods.fromJson(Map<String, dynamic> json) {
    return CreateOnlineRedemptionMethods(
      giftCard: json['giftCard'],
      discountCode: json['discountCode'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "giftCard": giftCard,
      "discountCode": discountCode,
    };
  }
}
