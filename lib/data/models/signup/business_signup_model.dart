import 'dart:io';

class BusinessSignupModel{

  String? category;
  String? name;
  String? tagline;
  String? description;
  String? email;
  String? password;
  String? businessPhoneNumber;
  String? businessEmail;
  String? businessWebsite;
  File? logo;
  List<String>? locations;

  BusinessSignupModel({
    this.category,
    this.name,
    this.tagline,
    this.description,
    this.email,
    this.password,
    this.businessEmail,
    this.businessPhoneNumber,
    this.businessWebsite,
    this.logo,
    this.locations
  });


  factory BusinessSignupModel.fromJson( Map<String, dynamic> json ){
    final data = json['data'];
    return BusinessSignupModel(
      category: data['category'] ?? '',
      name: data['name'] ?? '',
      tagline: data['tagLine'] ?? '',
      description: data['description'] ?? '',
      locations: data['locations'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "category": category,
      "name": name,
      "tagLine": tagline,
      "description": description,
      "businessPhoneNumber": businessPhoneNumber,
      "businessEmail": businessEmail,
      "businessWebsite": businessWebsite,
      "locations": locations,
      "role": "BUSINESS",
    };
  }


}