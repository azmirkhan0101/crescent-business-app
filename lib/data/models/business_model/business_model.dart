import 'dart:io';

class BusinessModel{

  String? category;
  final String? name;
  final String? tagline;
  final String? description;
  final String? email;
  final String? password;
  final File? logo;
  final List<String>? locations;

  BusinessModel({
    this.category,
    this.name,
    this.tagline,
    this.description,
    this.email,
    this.password,
    this.logo,
    this.locations
  });


}