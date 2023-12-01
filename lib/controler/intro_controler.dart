import 'package:get/get.dart';
import 'package:tic_tac_toe/view/xo_game.dart';

class IntroControler extends GetxController{
  RxBool loading = true.obs;
  @override
  void onReady() {
    Get.offAll(()=>XoGame());
  }
}