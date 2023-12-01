import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/xo_patches.dart';
import 'dart:math';

class XoControler extends GetxController {
  XoPatches xoPatches = Get.put(XoPatches());
  Map<String, RxList<RxList>>? mapPatches;
  RxBool computerGame=true.obs;
  RxBool playerTwo=false.obs;
  RxInt play = 0.obs;
  RxInt numRed = 0.obs;
  RxInt numBlue = 0.obs;
  RxInt numRedMinMax = 0.obs;
  RxInt numBlueMinMax = 0.obs;
  RxBool playRed = false.obs;
  RxBool playBlue = false.obs;
  RxBool playRedMinMax = false.obs;
  RxBool playBlueMinMax = false.obs;
  RxInt winX = 0.obs;
  RxInt winO = 0.obs;
  RxInt tie = 0.obs;
  RxString select = RxString("3*3 Puzzle ");
  RxInt row = 3.obs;
  RxInt column = 3.obs;
  RxInt gridStateLength = 9.obs;
  RxList<RxList>? orginalPatch;

  @override
  void onInit() {
    super.onInit();
    mapPatches = {
      "3*3 Puzzle ": xoPatches.puzzle33,
      "4*4 Puzzle ": xoPatches.puzzle44,
      "5*5 Puzzle ": xoPatches.puzzle55,
      "6*6 Puzzle ": xoPatches.puzzle66,
      "7*7 Puzzle ": xoPatches.puzzle77,
      "8*8 Puzzle ": xoPatches.puzzle88,
      "9*9 Puzzle ": xoPatches.puzzle99,
      "10*10 Puzzle ": xoPatches.puzzle1010,
    };
    row.value = mapPatches![select.value]![0].length;
    column.value = mapPatches![select.value]!.length;
    gridStateLength.value = column.value * row.value;
    orginalPatch = List.generate(
        column.value,
        (i) => List.generate(row.value, (j) => mapPatches![select.value]![i][j])
            .obs).obs;
  }

  change2Player(int x, int y) {
    if (canChange(x, y) && play.value % 2 != 0) {
      mapPatches![select.value]![x][y] = Colors.blue;
      play.value++;
    }
    if (canChange(x, y) && play.value % 2 == 0) {
      mapPatches![select.value]![x][y] = Colors.red;
      play.value++;
    }
  }
  changeComputer(int x, int y) {
    if (canChange(x, y)) {
      mapPatches![select.value]![x][y] = Colors.blue;
      minimax(mapPatches![select.value]!, 2, -100, 100, false);
    }
  }

  bool canChange(int x, int y) {
    return mapPatches![select.value]![x][y] == Colors.white ? true : false;
  }

  win(int r, int b) {
    if (r == row.value) {
      playRed.value = true;
      winO.value++;
    } else if (b == row.value) {
      playBlue.value = true;
      winX.value++;
    }
    numRed.value = 0;
    numBlue.value = 0;
  }

  winMinMax(int r, int b) {
    if (r == row.value) {
      playRedMinMax.value = true;
    } else if (b == row.value) {
      playBlueMinMax.value = true;
    }
    numRedMinMax.value = 0;
    numBlueMinMax.value = 0;
  }

  bool checkWin() {
    //check columns
    for (int j = 0; j < column.value; j++) {
      for (int i = 0; i < column.value; i++) {
        if (mapPatches![select.value]![i][j] == Colors.red) {
          numRed.value++;
        }
        if (mapPatches![select.value]![i][j] == Colors.blue) {
          numBlue.value++;
        }
      }
      win(numRed.value, numBlue.value);
    }
    //check rows
    for (int j = 0; j < column.value; j++) {
      for (int i = 0; i < column.value; i++) {
        if (mapPatches![select.value]![j][i] == Colors.red) {
          numRed.value++;
        }
        if (mapPatches![select.value]![j][i] == Colors.blue) {
          numBlue.value++;
        }
      }
      win(numRed.value, numBlue.value);
    }
    //check primary diameter
    for (int i = 0; i < row.value; i++) {
      for (int j = 0; j < row.value; j++) {
        if (mapPatches![select.value]![i][j] == Colors.red && i == j) {
          numRed.value++;
        }
        if (mapPatches![select.value]![i][j] == Colors.blue && i == j) {
          numBlue.value++;
        }
      }
    }
    win(numRed.value, numBlue.value);
    //check secondary diameter
    for (int i = 0; i < row.value; i++) {
      for (int j = 0; j < row.value; j++) {
        if (mapPatches![select.value]![i][j] == Colors.red && i + j == 2) {
          numRed.value++;
        }
        if (mapPatches![select.value]![i][j] == Colors.blue && i + j == 2) {
          numBlue.value++;
        }
      }
    }
    win(numRed.value, numBlue.value);

    if (playRed.value || playBlue.value) {
      return true;
    } else {
      return false;
    }
  }

  bool checkWinMinMax(List<List> s) {
    //check columns
    for (int j = 0; j < column.value; j++) {
      for (int i = 0; i < column.value; i++) {
        if (s[i][j] == Colors.red) {
          numRedMinMax.value++;
        }
        if (s[i][j] == Colors.blue) {
          numBlueMinMax.value++;
        }
      }
      winMinMax(numRedMinMax.value, numBlueMinMax.value);
    }
    //check rows
    for (int j = 0; j < column.value; j++) {
      for (int i = 0; i < column.value; i++) {
        if (s[j][i] == Colors.red) {
          numRedMinMax.value++;
        }
        if (s[j][i] == Colors.blue) {
          numBlueMinMax.value++;
        }
      }
      winMinMax(numRedMinMax.value, numBlueMinMax.value);
    }
    //check primary diameter
    for (int i = 0; i < row.value; i++) {
      for (int j = 0; j < row.value; j++) {
        if (s[i][j] == Colors.red && i == j) {
          numRedMinMax.value++;
        }
        if (s[i][j] == Colors.blue && i == j) {
          numBlueMinMax.value++;
        }
      }
    }
    winMinMax(numRedMinMax.value, numBlueMinMax.value);
    //check secondary diameter
    for (int i = 0; i < row.value; i++) {
      for (int j = 0; j < row.value; j++) {
        if (s[i][j] == Colors.red && i + j == 2) {
          numRedMinMax.value++;
        }
        if (s[i][j] == Colors.blue && i + j == 2) {
          numBlueMinMax.value++;
        }
      }
    }
    winMinMax(numRedMinMax.value, numBlueMinMax.value);

    if (playRedMinMax.value || playBlueMinMax.value) {
      return true;
    } else {
      return false;
    }
  }

  bool checkTie() {
    for (int i = 0; i < column.value; i++) {
      for (int j = 0; j < row.value; j++) {
        if (mapPatches![select.value]![i][j] == Colors.white) {
          return false;
        }
      }
    }
    if (checkWin() == false) {
      tie++;
      return true;
    } else {
      return false;
    }
  }

  bool checkTieMinMax(List<List> s) {
    for (int i = 0; i < column.value; i++) {
      for (int j = 0; j < row.value; j++) {
        if (s[i][j] == Colors.white) {
          return false;
        }
      }
    }
    if (checkWinMinMax(s) == false) {
      return true;
    } else {
      return false;
    }
  }

  int valueMinMax(List<List> s) {
    if (checkTieMinMax(s)) {
      return 0;
    } else if (checkWinMinMax(s) && playRedMinMax.value) {
      return -2;
    } else if (checkWinMinMax(s) && playBlueMinMax.value) {
      return 2;
    } else {
      return 1;
    }
  }

  int minimax(List<List> s, int depth, int alpha, int beta, bool isMaximizing,
      {bool firstTime = true}) {
    playRedMinMax.value = false;
    playBlueMinMax.value = false;
    int result = valueMinMax(s);
    if (depth == 0 || result != 1) {
      return result;
    }
    if (isMaximizing) {
      int finalScore = -10;
      int? finalI, finalJ;
      for (int i = 0; i < column.value; i++) {
        for (int j = 0; j < row.value; j++) {
          if (s[i][j] == Colors.white) {
            s[i][j] = Colors.blue;
            int score = minimax(s, --depth, alpha, beta, false, firstTime: false);
            s[i][j] = Colors.white;
            if (score > finalScore) {
              finalScore = score;
              finalI = i;
              finalJ = j;
            }
            alpha = max(alpha, finalScore); // update alpha
            if (beta <= alpha) {
              break; // alpha-beta pruning
            }
          }
        }
      }
      if (firstTime) {
        //mapPatches![select.value]![finalI!][finalJ!]= Colors.red;
        s[finalI!][finalJ!] = Colors.red;
      }
      return finalScore;
    } else {
      int finalScore = 10;
      int? finalI, finalJ;
      for (int i = 0; i < column.value; i++) {
        for (int j = 0; j < row.value; j++) {
          if (s[i][j] == Colors.white) {
            s[i][j] = Colors.red;
            int score = minimax(s, --depth, alpha, beta, true, firstTime: false);
            s[i][j] = Colors.white;
            if (score < finalScore) {
              finalScore = score;
              finalI = i;
              finalJ = j;
            }
            beta = min(beta, finalScore); // update beta
            if (beta <= alpha) {
              break; // alpha-beta pruning
            }
          }
        }
      }
      if (firstTime) {
        //mapPatches![select.value]![finalI!][finalJ!]= Colors.red;
        s[finalI!][finalJ!] = Colors.red;
      }
      return finalScore;
    }
  }

  @override
  refresh() {
    for (int i = 0; i < column.value; i++) {
      for (int j = 0; j < row.value; j++) {
        mapPatches![select.value]![i][j] = orginalPatch![i][j];
      }
    }
    numRed.value = 0;
    numBlue.value = 0;
    playRed.value = false;
    playBlue.value = false;
    playRedMinMax.value = false;
    playBlueMinMax.value = false;
  }
}
