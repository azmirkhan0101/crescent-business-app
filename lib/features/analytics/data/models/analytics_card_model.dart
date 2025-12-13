import 'package:organization/utils/assets_path.dart';

class StatsModel {
  final String title;
  final String subTitle;
  final String bottomText;
  final String bottomEndText;
  final String topIcon;
  final String bottomIcon;

  const StatsModel({
    required this.title,
    required this.subTitle,
    required this.bottomText,
    required this.bottomEndText,
    required this.topIcon,
    required this.bottomIcon,
  });

  // sample list
  static List<StatsModel> sampleList = [
    StatsModel(
      title: "Website Visits",
      subTitle: "Last 7 days",
      bottomText: "120",
      bottomEndText: "10.5%",
      topIcon: AssetsPath.clickIcon,
      bottomIcon: AssetsPath.increaseIcon,
    ),
    StatsModel(
      title: "Profile Views",
      subTitle: "Last 7 days",
      bottomText: "280",
      bottomEndText: "8.2%",
      topIcon: AssetsPath.profileIcon,
      bottomIcon: AssetsPath.increaseIcon,
    ),
    StatsModel(
      title: "Impressions",
      subTitle: "Last 7 days",
      bottomText: "120",
      bottomEndText: "12.3%",
      topIcon: AssetsPath.eyeTrackingIcon,
      bottomIcon: AssetsPath.increaseIcon,
    ),
    StatsModel(
      title: "Saves",
      subTitle: "Last 7 days",
      bottomText: "12",
      bottomEndText: "4.1%",
      topIcon: AssetsPath.bookMarkIcon,
      bottomIcon: AssetsPath.redPlayIcon,
    ),
  ];
}
