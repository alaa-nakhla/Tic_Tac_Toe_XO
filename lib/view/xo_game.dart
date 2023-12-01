import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/controler/xo_controler.dart';

class XoGame extends StatelessWidget {
  XoGame({super.key});

  final XoControler xoControler = Get.put(XoControler());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.white,
          backgroundColor: Colors.black,
          child: const Icon(Icons.refresh),
          onPressed: () {
            xoControler.refresh();
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Game XO"),
          actions: [
            IconButton(
                onPressed: () {
                  xoControler.computerGame.value=true;
                  xoControler.playerTwo.value=false;
                },
                icon: Icon(
                  Icons.computer,
                  color: xoControler.computerGame.value
                      ? Colors.red
                      : Colors.white,
                )),
            IconButton(
                onPressed: () {
                 xoControler.computerGame.value=false;
                 xoControler.playerTwo.value=true;
                },
                icon: Icon(
                  Icons.people_rounded,
                  color: xoControler.playerTwo.value
                      ? Colors.red
                      : Colors.white,
                )),
            DropdownButton(
                focusColor: Colors.white,
                dropdownColor: Colors.black,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                hint: const Text("Select Color  ",
                    style: TextStyle(color: Colors.white)),
                items: [
                  "3*3 Puzzle ",
                  "4*4 Puzzle ",
                  "5*5 Puzzle ",
                  "6*6 Puzzle ",
                  "7*7 Puzzle ",
                  "8*8 Puzzle ",
                  "9*9 Puzzle ",
                  "10*10 Puzzle ",
                ]
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.white),
                        )))
                    .toList(),
                value: xoControler.select.value,
                onChanged: (value) {
                  xoControler.refresh();
                  xoControler.computerGame.value?xoControler.select.value="3*3 Puzzle ":
                  xoControler.select.value = value.toString();
                  xoControler.row.value = xoControler
                      .mapPatches![xoControler.select.value]![0].length;
                  xoControler.column.value =
                      xoControler.mapPatches![xoControler.select.value]!.length;
                  xoControler.gridStateLength.value =
                      xoControler.column.value * xoControler.row.value;
                  xoControler.orginalPatch!.value = List.generate(
                      xoControler.column.value,
                      (i) => List.generate(
                              xoControler.row.value,
                              (j) => xoControler
                                  .mapPatches![xoControler.select.value]![i][j])
                          .obs);
                }),
            const SizedBox(width: 10),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                width: Get.width,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 5)),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: xoControler.row.value,
                      childAspectRatio: 1),
                  itemBuilder: (BuildContext context, int index) {
                    int x = 0, y = 0;
                    x = (index / xoControler.row.value).floor();
                    y = (index % xoControler.row.value);
                    return GestureDetector(
                      onTap: () {
                        xoControler.computerGame.value
                            ? xoControler.changeComputer(x, y)
                            : xoControler.change2Player(x, y);
                        xoControler.checkWin()
                            ? showDialog(
                                barrierColor: Colors.grey.withOpacity(0.5),
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Center(
                                        child: xoControler.playRed.value
                                            ? const Text("O You Win",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        "YujiHentaiganaAkari",
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : const Text("X You Win",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        "YujiHentaiganaAkari",
                                                    fontWeight:
                                                        FontWeight.bold))),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      MaterialButton(
                                        onPressed: () {
                                          xoControler.refresh();
                                          Navigator.pop(context);
                                        },
                                        color: Colors.white,
                                        textColor: Colors.black,
                                        child: const Text("Refresh",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  );
                                })
                            : xoControler.checkTie()
                                ? showDialog(
                                    barrierColor: Colors.grey.withOpacity(0.5),
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.black,
                                        title: const Center(
                                            child: Text("Tie",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        "YujiHentaiganaAkari",
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          MaterialButton(
                                            onPressed: () {
                                              xoControler.refresh();
                                              Navigator.pop(context);
                                            },
                                            color: Colors.white,
                                            textColor: Colors.black,
                                            child: const Text("Refresh",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        ],
                                      );
                                    })
                                : null;
                      },
                      child: Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2.5),
                                color: xoControler
                                    .mapPatches![xoControler.select]![x][y]),
                            child: Center(
                              child: xoControler.mapPatches![
                                          xoControler.select.value]![x][y] ==
                                      Colors.red
                                  ? Text("o",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 200 / xoControler.row.value,
                                          fontWeight: FontWeight.bold))
                                  : xoControler.mapPatches![xoControler
                                              .select.value]![x][y] ==
                                          Colors.blue
                                      ? Text("x",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  200 / xoControler.row.value,
                                              fontWeight: FontWeight.bold))
                                      : null,
                            ),
                          )),
                    );
                  },
                  itemCount: xoControler.gridStateLength.value,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: Get.width * 0.8,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 10,
                      )
                    ]),
                child: Center(
                  child: Text(
                    "X : ${xoControler.winX.value}   |  O : ${xoControler.winO.value}  |  T : ${xoControler.tie.value}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )),
        )));
  }
}
