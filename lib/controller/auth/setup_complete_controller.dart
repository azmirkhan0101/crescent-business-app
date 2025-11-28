import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/data/models/business_profile_model.dart';
import 'package:organization/utils/app_constants.dart';

class SetupCompleteController extends GetxController{
  
  final storage = GetStorage();
  var model = Rx<BusinessProfileModel?>(null);

  @override
  void onInit() {

    model.value = BusinessProfileModel.fromJson( storage.read( businessProfileModelKey ));

    super.onInit();
  }


}