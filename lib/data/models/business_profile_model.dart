

class BusinessProfileModel{

  String category;
  String name;
  String tagline;
  String description;
  String email;
  String businessPhoneNumber;
  String businessEmail;
  String businessWebsite;
  String? coverImage;
  String? logoImage;
  List<String>? locations;

  BusinessProfileModel({
    required this.category,
    required this.name,
    required this.tagline,
    required this.description,
    required this.email,
    required this.businessEmail,
    required this.businessPhoneNumber,
    required this.businessWebsite,
    required this.coverImage,
    required this.logoImage,
    required this.locations
  });


  factory BusinessProfileModel.fromJson( Map<String, dynamic> json ){

    return BusinessProfileModel(
        category: json['category'] ?? "",
        name: json['name'] ?? "",
        tagline: json['tagLine'] ?? "",
        description: json['description'] ?? "",
        email: json['auth']['email'] ?? "",
        businessEmail: json['businessEmail'] ?? "",
        businessPhoneNumber: json['businessPhoneNumber'] ?? "",
        businessWebsite: json['businessWebsite'] ?? "",
        coverImage: json['coverImage'] ?? "",
        logoImage: json['logoImage'] ?? "",
        locations: List<String>.from(json['locations'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "auth": {"email": email},
      "category": category,
      "name": name,
      "tagLine": tagline,
      "description": description,
      "businessPhoneNumber": businessPhoneNumber,
      "businessEmail": businessEmail,
      "businessWebsite": businessWebsite,
      "coverImage": coverImage,
      "logoImage": logoImage,
      "locations": locations,
    };
  }


}