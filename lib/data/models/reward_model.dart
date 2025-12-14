class RewardModel {
  final String id;
  final String business;
  final String title;
  final String description;
  final String? image;
  final String type;
  final String category;
  final int pointsCost;
  final int redemptionLimit;
  final int redeemedCount;
  final int remainingCount;
  final DateTime startDate;
  final DateTime? expiryDate;
  final String status;
  final bool isActive;

  final OnlineRedemptionMethods? onlineMethods;
  final InStoreRedemptionMethods? inStoreMethods;

  final List<RewardCode> codes;

  final bool featured;
  final int priority;
  final int redemptions;
  final List<dynamic> limitUpdateHistory;

  final DateTime createdAt;
  final DateTime updatedAt;

  RewardModel({
    required this.id,
    required this.business,
    required this.title,
    required this.description,
    this.image,
    required this.type,
    required this.category,
    required this.pointsCost,
    required this.redemptionLimit,
    required this.redeemedCount,
    required this.remainingCount,
    required this.startDate,
    this.expiryDate,
    required this.status,
    required this.isActive,
    this.onlineMethods,
    this.inStoreMethods,
    required this.codes,
    required this.featured,
    required this.priority,
    required this.redemptions,
    required this.limitUpdateHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json["_id"],
      business: json["business"],
      title: json["title"],
      description: json["description"],
      image: json["image"],
      type: json["type"],
      category: json["category"],
      pointsCost: json["pointsCost"],
      redemptionLimit: json["redemptionLimit"],
      redeemedCount: json["redeemedCount"],
      remainingCount: json["remainingCount"],
      startDate: DateTime.parse(json["startDate"]),
      expiryDate:
      json["expiryDate"] != null ? DateTime.parse(json["expiryDate"]) : null,
      status: json["status"],
      isActive: json["isActive"],
      onlineMethods: json["onlineRedemptionMethods"] != null
          ? OnlineRedemptionMethods.fromJson(json["onlineRedemptionMethods"])
          : null,
      inStoreMethods: json["inStoreRedemptionMethods"] != null
          ? InStoreRedemptionMethods.fromJson(
        json["inStoreRedemptionMethods"],
      )
          : null,
      codes:
      (json["codes"] as List).map((e) => RewardCode.fromJson(e)).toList(),
      featured: json["featured"],
      priority: json["priority"],
      redemptions: json["redemptions"],
      limitUpdateHistory: json["limitUpdateHistory"] ?? [],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "business": business,
      "title": title,
      "description": description,
      "image": image,
      "type": type,
      "category": category,
      "pointsCost": pointsCost,
      "redemptionLimit": redemptionLimit,
      "redeemedCount": redeemedCount,
      "remainingCount": remainingCount,
      "startDate": startDate.toIso8601String(),
      "expiryDate": expiryDate?.toIso8601String(),
      "status": status,
      "isActive": isActive,
      "onlineRedemptionMethods": onlineMethods?.toJson(),
      "inStoreRedemptionMethods": inStoreMethods?.toJson(),
      "codes": codes.map((e) => e.toJson()).toList(),
      "featured": featured,
      "priority": priority,
      "redemptions": redemptions,
      "limitUpdateHistory": limitUpdateHistory,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}

// ---------------------------------------------------------------
// Online Redemption Methods
// ---------------------------------------------------------------
class OnlineRedemptionMethods {
  final bool discountCode;
  final bool giftCard;

  OnlineRedemptionMethods({
    required this.discountCode,
    required this.giftCard,
  });

  factory OnlineRedemptionMethods.fromJson(Map<String, dynamic> json) {
    return OnlineRedemptionMethods(
      discountCode: json["discountCode"],
      giftCard: json["giftCard"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "discountCode": discountCode,
      "giftCard": giftCard,
    };
  }
}

// ---------------------------------------------------------------
// In-Store Redemption Methods
// ---------------------------------------------------------------
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
      qrCode: json["qrCode"],
      staticCode: json["staticCode"],
      nfcTap: json["nfcTap"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "qrCode": qrCode,
      "staticCode": staticCode,
      "nfcTap": nfcTap,
    };
  }
}

// ---------------------------------------------------------------
// Reward Codes
// ---------------------------------------------------------------
class RewardCode {
  final String code;
  final bool isGiftCard;
  final bool isDiscountCode;
  final bool isUsed;

  final String? redemptionId;
  final DateTime? usedAt;
  final String? usedBy;

  RewardCode({
    required this.code,
    required this.isGiftCard,
    required this.isDiscountCode,
    required this.isUsed,
    this.redemptionId,
    this.usedAt,
    this.usedBy,
  });

  factory RewardCode.fromJson(Map<String, dynamic> json) {
    return RewardCode(
      code: json["code"],
      isGiftCard: json["isGiftCard"],
      isDiscountCode: json["isDiscountCode"],
      isUsed: json["isUsed"],
      redemptionId: json["redemptionId"],
      usedAt:
      json["usedAt"] != null ? DateTime.parse(json["usedAt"]) : null,
      usedBy: json["usedBy"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "isGiftCard": isGiftCard,
      "isDiscountCode": isDiscountCode,
      "isUsed": isUsed,
      "redemptionId": redemptionId,
      "usedAt": usedAt?.toIso8601String(),
      "usedBy": usedBy,
    };
  }
}
