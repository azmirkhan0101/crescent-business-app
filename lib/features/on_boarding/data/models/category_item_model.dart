import 'dart:ui';
import 'package:organization/utils/assets_path.dart';

class CategoryModel {
  final String title;
  final String iconPath;
  final String image;
  final int color; // hex color

  const CategoryModel({
    required this.image,
    required this.title,
    required this.iconPath,
    required this.color,
  });

  Color get colorCode => Color(color);

  static List<CategoryModel> sampleList = [
    CategoryModel(
      image: AssetsPath.salonImage,
      title: "Salon",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF4CAF50,
    ),
    CategoryModel(
      image: AssetsPath.wellnessIcon,
      title: "Wellness & Spa",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF2196F3,
    ),
    CategoryModel(
      image: AssetsPath.realStoreIcon,
      title: "Retail Store",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFFFF9800,
    ),
    CategoryModel(
      image: AssetsPath.bakeryIcon,
      title: "Bakery",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFFE91E63,
    ),
    CategoryModel(
      image: AssetsPath.cafeIcon,
      title: "Cafe",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF9C27B0,
    ),
    CategoryModel(
      image: AssetsPath.restaurantIcon,
      title: "Restaurant",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF673AB7,
    ),
    CategoryModel(
      image: AssetsPath.autoServiceIcon,
      title: "Auto Services",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF795548,
    ),
    CategoryModel(
      image: AssetsPath.otherIcon,
      title: "Other",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF607D8B,
    ),
  ];
}
