import '../../../../utils/assets_path.dart';

class RewardOption {
  final String topIcon;
  final String title;
  final String subtitle;
  final String bottomIcon1;
  final String bottomIcon2;
  final String bottomText;

  RewardOption({
    required this.topIcon,
    required this.title,
    required this.subtitle,
    required this.bottomIcon1,
    required this.bottomIcon2,
    required this.bottomText,
  });
}


final List<RewardOption> rewardOptions = [
  RewardOption(
    topIcon: AssetsPath.rewardDiscountIcon,
    title: 'Free Coffee',
    subtitle: 'Expires: June 30, 2025',
    bottomIcon1: AssetsPath.contactLess1Icon,
    bottomIcon2: AssetsPath.qrCodeIcon,
    bottomText: 'Redeem via:',
  ),
  RewardOption(
    topIcon: AssetsPath.rewardFreeIcon,
    title: 'Free Muffin',
    subtitle: 'Expires: June 30, 2025',
    bottomIcon1: AssetsPath.contactLess1Icon,
    bottomIcon2: AssetsPath.qrCodeIcon,
    bottomText: 'Redeem via:',
  ),
  RewardOption(
    topIcon: AssetsPath.rewardDiscountIcon,
    title: '20% Off Latte',
    subtitle: 'Expires: June 30, 2025',
    bottomIcon1: AssetsPath.contactLess1Icon,
    bottomIcon2: AssetsPath.qrCodeIcon,
    bottomText: 'Redeem via:',
  ),
  RewardOption(
    topIcon: AssetsPath.rewardFreeIcon,
    title: 'Buy 1 Get 1 Free',
    subtitle: 'Expires: June 30, 2025',
    bottomIcon1: AssetsPath.contactLess1Icon,
    bottomIcon2: AssetsPath.qrCodeIcon,
    bottomText: 'Redeem via:',
  ),
  RewardOption(
    topIcon: AssetsPath.rewardDiscountIcon,
    title: '20% Off Latte',
    subtitle: 'Expires: June 30, 2025',
    bottomIcon1: AssetsPath.contactLess1Icon,
    bottomIcon2: AssetsPath.qrCodeIcon,
    bottomText: 'Redeem via:',
  ),
  RewardOption(
    topIcon: AssetsPath.rewardFreeIcon,
    title: 'Buy 1 Get 1 Free',
    subtitle: 'Expires: June 30, 2025',
    bottomIcon1: AssetsPath.contactLess1Icon,
    bottomIcon2: AssetsPath.qrCodeIcon,
    bottomText: 'Redeem via:',
  ),
];
