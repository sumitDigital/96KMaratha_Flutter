import 'package:get/get.dart';

class BasicFilterController extends GetxController{
var selectedStatus = "".obs;

   void updateStatus(String value){
    selectedStatus.value = value;
  }
}