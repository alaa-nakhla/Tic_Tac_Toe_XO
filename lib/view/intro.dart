import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controler/intro_controler.dart';
class Intro extends StatelessWidget{
  final IntroControler introControler = Get.put(IntroControler());
   Intro({super.key});
  @override
  Widget build(BuildContext context) {
   return  Scaffold(
     body: Center(
       child: introControler.loading.value?
       const CircularProgressIndicator():null,
     ),
   );
  }
}