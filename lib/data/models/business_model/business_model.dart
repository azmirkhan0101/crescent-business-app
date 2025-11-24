import 'dart:io';

class BusinessModel{

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

  BusinessModel({
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