

class BusinessProfileModel{

  final String category;
  final String name;
  final String tagline;
  final String description;
  final String email;
  final String businessPhoneNumber;
  final String businessEmail;
  final String businessWebsite;
  final String logoPath;
  final List<String> locations;

  BusinessProfileModel({
    required this.category,
    required this.name,
    required this.tagline,
    required this.description,
    required this.email,
    required this.businessEmail,
    required this.businessPhoneNumber,
    required this.businessWebsite,
    required this.logoPath,
    required this.locations
  });


  factory BusinessProfileModel.fromJson( Map<String, dynamic> json ){

    final data = json['data'];
    if( data == null ){
      print("Error in modellll: data is null ${data}");
    }
    return BusinessProfileModel(
        category: data['category'] ?? "",
        name: data['name'] ?? "",
        tagline: data['tagLine'] ?? "",
        description: data['description'] ?? "",
        email: data['email'] ?? "",
        businessEmail: data['businessEmail'],
        businessPhoneNumber: data['businessPhoneNumber'] ?? "",
        businessWebsite: data['businessWebsite'] ?? "",
        logoPath: data['logoPath'] ?? "",
        locations: List<String>.from(data['locations'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
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