

class BusinessProfileModel{

  String category;
  String name;
  String tagline;
  String description;
  String email;
  String businessId;
  String businessAuthId;
  String businessPhoneNumber;
  String businessEmail;
  String businessWebsite;
  String? coverImage;
  String? logoImage;
  bool? isSubscribed;
  List<String>? locations;

  BusinessProfileModel({
    required this.category,
    required this.name,
    required this.tagline,
    required this.description,
    required this.email,
    required this.businessId,
    required this.businessAuthId,
    required this.businessEmail,
    required this.businessPhoneNumber,
    required this.businessWebsite,
    required this.coverImage,
    required this.logoImage,
    required this.isSubscribed,
    required this.locations
  });


  factory BusinessProfileModel.fromJson( Map<String, dynamic> json ){

    return BusinessProfileModel(
        category: json['category'] ?? "",
        name: json['name'] ?? "",
        tagline: json['tagLine'] ?? "",
        description: json['description'] ?? "",
        email: json['auth']['email'] ?? "",
        businessId: json['_id'] ?? "",
        businessAuthId: json['auth']['_id'] ?? "",
        businessEmail: json['businessEmail'] ?? "",
        businessPhoneNumber: json['businessPhoneNumber'] ?? "",
        businessWebsite: json['businessWebsite'] ?? "",
        coverImage: json['coverImage'] ?? "",
        logoImage: json['logoImage'] ?? "",
        isSubscribed: json['isSubscribed'] ?? true,
        locations: List<String>.from(json['locations'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": businessId,
      "auth": {
        "_id": businessAuthId,
        "email": email
      },
      "category": category,
      "name": name,
      "tagLine": tagline,
      "description": description,
      "businessPhoneNumber": businessPhoneNumber,
      "businessEmail": businessEmail,
      "businessWebsite": businessWebsite,
      "coverImage": coverImage,
      "logoImage": logoImage,
      "isSubscribed": isSubscribed,
      "locations": locations,
    };
  }


}