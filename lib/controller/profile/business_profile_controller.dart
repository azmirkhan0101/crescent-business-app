import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/data/models/business_profile_model.dart';
import 'package:organization/utils/app_constants.dart';

class BusinessProfileController extends GetxController{

  final storage = GetStorage();
  late BusinessProfileModel model;

  @override
  void onInit() {

    model = BusinessProfileModel.fromJson( storage.read( businessProfileModelKey ));

    super.onInit();
  }
}