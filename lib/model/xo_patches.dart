import 'package:flutter/material.dart';
import 'package:get/get.dart';

class XoPatches extends GetxController {
  RxList<RxList> puzzle33 = List.generate(3, (index) => List.generate(3, (index) => Colors.white).obs).obs;
  RxList<RxList> puzzle44 = List.generate(4, (index) => List.generate(4, (index) => Colors.white).obs).obs;
  RxList<RxList> puzzle55 = List.generate(5, (index) => List.generate(5, (index) => Colors.white).obs).obs;
  RxList<RxList> puzzle66 = List.generate(6, (index) => List.generate(6, (index) => Colors.white).obs).obs;
  RxList<RxList> puzzle77 = List.generate(7, (index) => List.generate(7, (index) => Colors.white).obs).obs;
  RxList<RxList> puzzle88 = List.generate(8, (index) => List.generate(8, (index) => Colors.white).obs).obs;
  RxList<RxList> puzzle99 = List.generate(9, (index) => List.generate(9, (index) => Colors.white).obs).obs;
  RxList<RxList> puzzle1010 = List.generate(10, (index) => List.generate(10, (index) => Colors.white).obs).obs;
}
