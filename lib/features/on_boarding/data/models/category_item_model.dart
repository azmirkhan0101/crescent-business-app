import 'dart:ui';
import 'package:organization/utils/assets_gen/assets.gen.dart';
import 'package:organization/utils/assets_path.dart';

class CategoryModel {
  final String title;
  final String iconPath;
  final String icon;
  final int color; // hex color

  const CategoryModel({
    required this.icon,
    required this.title,
    required this.iconPath,
    required this.color,
  });

  Color get colorCode => Color(color);

  static List<CategoryModel> sampleList = [
    CategoryModel(
      icon: Assets.icons.saloon.keyName,
      title: "Salon",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF4CAF50,
    ),
    CategoryModel(
      icon: Assets.icons.wellness.keyName,
      title: "Wellness & Spa",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF2196F3,
    ),
    CategoryModel(
      icon: Assets.icons.retail.keyName,
      title: "Retail Store",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFFFF9800,
    ),
    CategoryModel(
      icon: Assets.icons.bakery.keyName,
      title: "Bakery",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFFE91E63,
    ),
    CategoryModel(
      icon: Assets.icons.cafe.keyName,
      title: "Cafe",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF9C27B0,
    ),
    CategoryModel(
      icon: Assets.icons.restaurant.keyName,
      title: "Restaurant",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF673AB7,
    ),
    CategoryModel(
      icon: Assets.icons.auto.keyName,
      title: "Auto Services",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF795548,
    ),
    CategoryModel(
      icon: Assets.icons.other.keyName,
      title: "Other",
      iconPath: AssetsPath.radioUnselected,
      color: 0xFF607D8B,
    ),
  ];
}
