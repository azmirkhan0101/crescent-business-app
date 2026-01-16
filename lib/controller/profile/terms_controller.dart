import 'dart:convert';

import 'package:get/get.dart';

import '../../utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class TermsController extends GetxController{

  RxString htmlData = "".obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {

    getTermsAndConditions();
    super.onInit();
  }

  getTermsAndConditions() async{

    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.termsAndConditions );
    Map<String, String>  headers = {
      'Accept': 'text/html, application/json',
  };

    try {
      isLoading.value = true;

      http.Response response = await http.get(uri, headers: headers );

      if( response.statusCode == 200 ){
        htmlData.value = (jsonDecode(response.body))['data']['terms'];
      }
    }catch(e){
    }finally{
      isLoading.value = false;
    }

  }
}