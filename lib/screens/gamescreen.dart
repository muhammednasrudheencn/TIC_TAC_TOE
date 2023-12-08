// ignore_for_file: must_be_immutable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_game/screens/home.dart';

class GameScreen extends StatefulWidget {
  String player1;
  String player2;
  GameScreen({super.key, required this.player1, required this.player2});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> board;
  late String currentplayer;
  late String winner;
  late bool gameover;

  @override
  void initState() {
    super.initState();
    board = List.generate(3, (_) => List.generate(3, (_) => ''));
    currentplayer = 'x';
    winner = '';
    gameover = false;
  }

  void resetgame() {
    setState(() {
      board = List.generate(3, (_) => List.generate(3, (_) => ''));
      currentplayer = 'x';
      winner = '';
      gameover = false;
    });
  }

  void makemove(int row, int col) {
    if (board[row][col] != '' || gameover) {
      return;
    }
    setState(() {
      board[row][col] = currentplayer;

      if (board[row][0] == currentplayer &&
          board[row][1] == currentplayer &&
          board[row][2] == currentplayer) {
        winner = currentplayer;
        gameover = true;
      } else if (board[0][col] == currentplayer &&
          board[1][col] == currentplayer &&
          board[2][col] == currentplayer) {
        winner = currentplayer;
        gameover = true;
      } else if (board[0][0] == currentplayer &&
          board[1][1] == currentplayer &&
          board[2][2] == currentplayer) {
        winner = currentplayer;
        gameover = true;
      } else if (board[0][2] == currentplayer &&
          board[1][1] == currentplayer &&
          board[2][0] == currentplayer) {
        winner = currentplayer;
        gameover = true;
      }

      currentplayer = currentplayer == 'x' ? 'o' : 'x';

      if (!board.any((row) => row.any((cell) => cell == ''))) {
        gameover = true;
        winner = 'TIE';
      }

      if (winner != '') {
        AwesomeDialog(
          context: context,
          dialogType:
              winner == 'TIE' ? DialogType.question : DialogType.success,
          animType: AnimType.rightSlide,
          btnOkText: 'Play Again',
          title: winner == 'x'
              ? '${widget.player1}  won !'.toUpperCase()
              : winner == 'o'
                  ? '${widget.player2}  Won !'.toUpperCase()
                  : 'TIE',
          btnOkOnPress: () => resetgame(),
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 50, 38, 65),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),
            SizedBox(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentplayer == 'x'
                        ? '${widget.player1} [$currentplayer]'.toUpperCase()
                        : '${widget.player2} [$currentplayer]'.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: currentplayer == 'x'
                            ? const Color(0xFFE25041)
                            : const Color(0xFF1CBD9E)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(5),
              child: GridView.builder(
                itemCount: 9,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => makemove(row, col),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 22, 13, 39),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: TextStyle(
                              fontSize: 120,
                              fontWeight: FontWeight.bold,
                              color: board[row][col] == 'x'
                                  ? const Color(0xFFE25041)
                                  : const Color(0xFF1CBD9E)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => resetgame(),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: Text(
                        'Rset Game',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => const HomeScreen())),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 21),
                      child: Text(
                        'Restart Game',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
