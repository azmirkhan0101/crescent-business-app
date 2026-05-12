// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:organization/core/api_response.dart';
// import 'package:organization/core/api_service.dart';
//
// class InAppPurchaseController extends GetxController {
//
//   final ApiService apiService = Get.find<ApiService>();
//
//   // IAP
//   final InAppPurchase _iap = InAppPurchase.instance;
//
//   static const Map<String, String> _planToProductId = {
//     'monthly': 'com.raiyanrahmat.crescentChange.monthly',
//     'yearly': 'com.raiyanrahmat.crescentChange.yearly'
//   };
//
//   static Set<String> get _productIds => _planToProductId.values.toSet();
//
//   final RxList<ProductDetails> products = <ProductDetails>[].obs;
//   final RxBool isAvailable = false.obs;
//   final RxBool isPurchasing = false.obs;
//   final RxBool isSubscribed = false.obs;
//
//   late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     _initialize();
//   }
//
//   // ─── IAP ────────────────────────────────────────────────────────────────────
//
//   Future<void> _initialize() async {
//     isAvailable.value = await _iap.isAvailable();
//     if (!isAvailable.value) {
//       debugPrint('xxx => Store not available');
//       return;
//     }
//
//     _purchaseSubscription = _iap.purchaseStream.listen(
//       _onPurchaseUpdate,
//       onError: (error) => debugPrint('xxx => Purchase stream error: $error'),
//     );
//
//     await _loadProducts();
//     // await restorePurchases();
//   }
//
//   Future<void> _loadProducts() async {
//     final ProductDetailsResponse response =
//     await _iap.queryProductDetails(_productIds);
//
//     if (response.error != null) {
//       debugPrint('xxx => Error loading products: ${response.error}');
//       return;
//     }
//
//     if (response.productDetails.isEmpty) {
//       debugPrint(
//           'xxx => No products found — check Product IDs match App Store Connect');
//       return;
//     }
//
//     response.productDetails.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
//     products.value = response.productDetails;
//     debugPrint('xxx => Loaded ${products.length} products');
//   }
//
//   /// Called from UI with plan title (e.g. "Silver - Barbers Shift")
//   Future<void> subscribeToPlan(String planType) async {
//
//     final key = planType.toLowerCase();
//     String? productId;
//
//     if (key.contains('monthly')) {
//       productId = _planToProductId['monthly'];
//     } else{
//       productId = _planToProductId['yearly'];
//     }
//
//     if (productId == null) {
//       debugPrint('xxx => No product ID found for: $planType');
//       return;
//     }
//
//     final product = products.firstWhereOrNull((p) => p.id == productId);
//
//     if (product == null) {
//       debugPrint('xxx => Product not loaded: $productId');
//       Get.snackbar('Error', 'Product not available. Try again later.',
//           snackPosition: SnackPosition.TOP);
//       return;
//     }
//
//     await _subscribe(product);
//   }
//
//   Future<void> _subscribe(ProductDetails product) async {
//     if (isPurchasing.value) return;
//     isPurchasing.value = true;
//     try {
//       final PurchaseParam purchaseParam = PurchaseParam(
//         productDetails: product,
//       );
//       await _iap.buyNonConsumable(purchaseParam: purchaseParam);
//     } catch (e) {
//       debugPrint('xxx => Purchase error: $e');
//       isPurchasing.value = false;
//     }
//   }
//
//   void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
//     for (final purchase in purchases) {
//       _handlePurchase(purchase);
//     }
//   }
//
//   Future<void> _handlePurchase(PurchaseDetails purchase) async {
//     debugPrint('xxx => Purchase status: ${purchase.status}');
//     debugPrint('xxx => Purchase productID: ${purchase.productID}');
//
//     if (purchase.status == PurchaseStatus.pending) {
//       isPurchasing.value = true;
//       debugPrint('xxx => Purchase pending...');
//     } else if (purchase.status == PurchaseStatus.purchased ||
//         purchase.status == PurchaseStatus.restored) {
//       final valid = await _verifyPurchase(purchase);
//       if (valid) {
//         isSubscribed.value = true;
//         debugPrint('xxx => Purchase successful: ${purchase.productID}');
//         Get.snackbar('Success', 'Subscription activated!',
//             snackPosition: SnackPosition.TOP);
//       }
//     } else if (purchase.status == PurchaseStatus.error) {
//       debugPrint('xxx => Purchase error: ${purchase.error}');
//       Get.snackbar('Error', 'Purchase failed. Please try again.',
//           snackPosition: SnackPosition.TOP);
//     } else if (purchase.status == PurchaseStatus.canceled) {
//       debugPrint('xxx => Purchase canceled');
//     }
//
//     if (purchase.pendingCompletePurchase) {
//       await _iap.completePurchase(purchase);
//     }
//
//     isPurchasing.value = false;
//   }
//
//   Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
//     // TODO: Send purchase.verificationData.serverVerificationData
//     // to your backend for server-side verification
//
//     Map<String, dynamic> payLoad = {
//             'receiptData': purchase.verificationData.serverVerificationData,
//             'productId': purchase.productID
//           };
//     ApiResponse response = await apiService.networkRequest(
//       method: "POST",
//       isAuthRequired: true,
//       endPoint: "",//TODO: ADD ENDPOINT
//       body: payLoad
//     );
//
//     if( response.statusCode == 200 ){
//       print("IAP SUCCESS");
//       return true;
//     }else{
//       print("IAP FAILED");
//       return false;
//     }
//   }
//
//   Future<void> restorePurchases() async {
//     try {
//       await _iap.restorePurchases();
//       debugPrint('xxx => Restore purchases called');
//     } catch (e) {
//       debugPrint('xxx => Restore error: $e');
//     }
//   }
//
//   @override
//   void onClose() {
//     _purchaseSubscription.cancel();
//     super.onClose();
//   }
//
//   List<String> paymentConditions = [
//     "1.Unlock 3 Exclusive Deals",
//     "2.Extended Redemption Period",
//     "3.Bonus Savings Opportunity",
//   ];
// }