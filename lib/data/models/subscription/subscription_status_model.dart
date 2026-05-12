enum SubPlan { none, monthly, yearly }

enum SubSource { none, promotional, appStore, googlePlay }

class SubscriptionStatusModel {
  final bool isPremium;
  final DateTime? expirationDate;
  final SubPlan plan;
  final SubSource source;
  final bool isPromotional; // 6-month free trial via backend
  final bool willAutoRenew;

  const SubscriptionStatusModel({
    required this.isPremium,
    this.expirationDate,
    this.plan = SubPlan.none,
    this.source = SubSource.none,
    this.isPromotional = false,
    this.willAutoRenew = false,
  });

  // Convenience constructor for non-premium state
  const SubscriptionStatusModel.free()
      : isPremium = false,
        expirationDate = null,
        plan = SubPlan.none,
        source = SubSource.none,
        isPromotional = false,
        willAutoRenew = false;

  int? get daysRemaining => expirationDate != null
      ? expirationDate!.difference(DateTime.now()).inDays
      : null;

  // Show "subscribe soon" banner when trial has ≤14 days left
  bool get showTrialConversionBanner =>
      isPromotional && daysRemaining != null && daysRemaining! <= 14;

  bool get isExpiringSoon =>
      daysRemaining != null && daysRemaining! <= 7 && isPremium;
}