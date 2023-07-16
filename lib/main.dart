// ignore_for_file: non_constant_identifier_names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birdle v2',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
          fontFamily: 'Helvetica',
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
              shadowColor: Colors.grey[300],
              surfaceTintColor: Colors.grey[300],
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.grey[300],
            shape: const CircleBorder(),
          ),
          textTheme: const TextTheme(
              labelLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              headlineSmall: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ))),
      home: const MyHomePage(title: 'Birdle v2'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Game game = Game();

class _MyHomePageState extends State<MyHomePage> {
  final String let1 = "QWERTYUIOP";
  final String let2 = "ASDFGHJKL";
  final String let3 = "ZXCVBNM";
  String guess = "";
  int onRow = 0;
  int _GUESSES = 0;
  int _LETTERS = 0;
  bool hardMode = false;
  bool correct = false;
  dynamic guesses;
  dynamic parses;

  @override
  initState() {
    super.initState();
    resetGame(false);
  }

  void enter() {
    setState(() {
      if (!correct) {
        debugPrint("guess is $guess");
        if (game.validGuess(guess) && !correct) {
          String parsedGuess = game.parseGuess(guess);
          debugPrint(parsedGuess);
          if (game.isCorrect(parsedGuess)) {
            correct = true;
          }
          for (int i = 0; i < parses[0].length; i++) {
            parses[onRow][i] = parsedGuess[i];
          }
          updateDisp();
          onRow++;
          guess = "";
          if (onRow == guesses.length && !correct) {
            //fail();
          }
        } else {
          debugPrint("Please enter valid guess");
        }
      }
    });
  }

  void delete() {
    setState(() {
      if (!correct) {
        debugPrint('deleted');
        if (guess.isNotEmpty && !correct) {
          guess = guess.substring(0, guess.length - 1);
        }
        updateDisp();
      }
    });
  }

  void letter(String c) {
    setState(() {
      if (!correct) {
        debugPrint('clicked $c');
        if (guess.length < _LETTERS) {
          guess += c;
        }
        updateDisp();
      }
    });
  }

  void fail() {
    //
  }

  void setMode(bool hardMode) {
    setState(() {
      resetGame(hardMode);
    });
  }

  void resetGame(bool hardMode) {
    game.loadMode(hardMode);
    _GUESSES = game.getWord().length + 1;
    _LETTERS = game.getWord().length;
    guess = "";
    onRow = 0;
    guesses = List.generate(_GUESSES, (i) => List.filled(_LETTERS, ""),
        growable: false);
    parses = List.generate(_GUESSES, (i) => List.filled(_LETTERS, ""),
        growable: false);
    debugPrint('mode set to hardmode: $hardMode');
    debugPrint('GUESSES: $_GUESSES, ${guesses.length}');
    debugPrint('LETTERS: $_LETTERS, ${guesses[0].length}');
    correct = false;
    updateDisp();
  }

  void updateDisp() {
    setState(() {
      if (!correct) {
        for (int c = 0; c < guesses[0].length; c++) {
          if (onRow < guesses.length) {
            if (c < guess.length) {
              guesses[onRow][c] = guess[c];
            } else {
              guesses[onRow][c] = "";
            }
          }
        }
      }
    });
  }

  Widget letterBox(String let, String col) {
    if (col == "O") {
      return Container(
          padding: const EdgeInsets.all(6),
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 124, 124, 124)),
          child: Center(
            child: Text(
              let,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            ),
          ));
    } else if (col == "G") {
      return Container(
          padding: const EdgeInsets.all(6),
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 108, 172, 100)),
          child: Center(
            child: Text(
              let,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            ),
          ));
    } else if (col == "Y") {
      return Container(
          padding: const EdgeInsets.all(6),
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 204, 180, 92)),
          child: Center(
            child: Text(
              let,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            ),
          ));
    }
    return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[350]!, width: 2),
            color: Colors.white),
        child: Center(
          child: Text(
            let,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30.0,
            ),
          ),
        ));
  }

  Widget keyBox(String c, String col) {
    return Container(
        key: Key("btn_$c"),
        margin: const EdgeInsets.all(4.0),
        constraints: const BoxConstraints(maxWidth: 45),
        child: TextButton(
          style: (col == 'O')
              ? TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 124, 124, 124),
                  foregroundColor: Colors.white,
                  fixedSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                )
              : (col == 'G')
                  ? TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 108, 172, 100),
                      foregroundColor: Colors.white,
                      fixedSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                    )
                  : (col == 'Y')
                      ? TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 204, 180, 92),
                          foregroundColor: Colors.white,
                          fixedSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                        )
                      : TextButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          fixedSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                        ),
          onPressed: () {
            letter(c);
          },
          child: Text(c),
        ));
  }

  Widget deleteButton() {
    return Container(
        margin: const EdgeInsets.all(4.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            fixedSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            padding: const EdgeInsets.all(20.0),
          ),
          onPressed: () {
            delete();
          },
          child: const Text("<<"),
        ));
  }

  Widget enterButton() {
    return Container(
        margin: const EdgeInsets.all(4.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            fixedSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            padding: const EdgeInsets.all(20.0),
          ),
          onPressed: () {
            enter();
          },
          child: const Text("->"),
        ));
  }

  Widget modeSwitch() {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              setMode(false);
            },
            child: const Text('New game (easy mode)')),
        ElevatedButton(
            onPressed: () {
              setMode(true);
            },
            child: const Text('New game (hard mode)'))
      ],
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Birdle Help"),
          content: const Text(
              "Birdle is a bird version of the popular word game Wordle. The aim is to guess the mystery bird, which is 5 letters long.\n\nTo play, use the on-screen keyboard or the computer keyboard to enter letters. Every guess must be 5 letters long, and MUST be a bird in the bird list stored in the game. Then click enter (->).\n\nIf a letter is yellow, it means that it's in the name of the mystery bird, but not in the right spot.\nIf it's green, it's in the word and in the right spot.\nGray is not in the word at all.\n\nFor example, say the guess is **crane**, and the boxes turn `gray`, `gray`, `gray`, `yellow`, `green`.  Then there's a chance that the mystery bird is **snipe**, because it contains an n that's not in the fourth spot, and it ends with an e.\n\nHave fun!"),
          actions: <Widget>[
            FilledButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<LogicalKeyboardKey> keys = [];

  @override
  Widget build(BuildContext context) => RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) {
        final key = event.logicalKey;
        if (event is RawKeyUpEvent) {
          setState(() => keys.clear());
        }
        if (keys.contains(key)) return;
        if (event is RawKeyDownEvent) {
          setState(() => keys.add(key));
          if (event.isKeyPressed(LogicalKeyboardKey.keyA)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyA) {
              letter('A');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyB)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyB) {
              letter('B');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyC)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyC) {
              letter('C');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyD)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyD) {
              letter('D');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyE)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyE) {
              letter('E');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyF)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyF) {
              letter('F');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyG)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyG) {
              letter('G');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyH)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyH) {
              letter('H');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyI)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyI) {
              letter('I');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyJ)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyJ) {
              letter('J');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyK)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyK) {
              letter('K');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyL)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyL) {
              letter('L');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyM)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyM) {
              letter('M');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyN)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyN) {
              letter('N');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyO)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyO) {
              letter('O');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyP)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyP) {
              letter('P');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyQ)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyQ) {
              letter('Q');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyR)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyR) {
              letter('R');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyS)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyS) {
              letter('S');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyT)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyT) {
              letter('T');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyU)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyU) {
              letter('U');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyV)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyV) {
              letter('V');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyW)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyW) {
              letter('W');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyX)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyX) {
              letter('X');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyY)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyY) {
              letter('Y');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.keyZ)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.keyZ) {
              letter('Z');
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.enter) {
              enter();
            }
          }
          if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
            if (keys[keys.length - 1] == LogicalKeyboardKey.backspace) {
              delete();
            }
          }
        }
      },
      child: Scaffold(
          body: Stack(children: [
        Center(
            child: Column(
          children: [
            const SizedBox(height: 100),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  //minWidth: 400,
                  maxWidth: (_LETTERS * 80),
                ),
                //child: FittedBox(
                //fit: BoxFit.scaleDown,
                child: GridView.count(
                  primary: false,
                  //physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  // MAKE IT SO THAT ROWS OF BUTTONS AREN'T PUSHED TO SCREEN BOTTOM
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: _LETTERS,
                  children: <Widget>[
                    for (int i = 0; i < _GUESSES; i++) ...[
                      for (int j = 0; j < _LETTERS; j++) ...[
                        letterBox(guesses[i][j], parses[i][j]),
                      ]
                    ]
                  ],
                ),
                // ), //FittedBox
              ),
            ),
            //const SizedBox(height: 70),
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < let1.length; i++) ...[
                          keyBox(let1[i], game.getLetterData(let1[i])),
                        ]
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < let2.length; i++) ...[
                          keyBox(let2[i], game.getLetterData(let2[i])),
                        ]
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        deleteButton(),
                        for (int i = 0; i < let3.length; i++) ...[
                          keyBox(let3[i], game.getLetterData(let3[i])),
                        ],
                        enterButton(),
                      ])
                ])),
          ],
        )),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //SizedBox(height: 100),
                  /*ElevatedButton.icon(
                        icon: const Icon(Icons.replay),
                        label: const Text(''),
                        onPressed: () {
                          setMode(false);
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.replay),
                        label: const Text('Hard'),
                        onPressed: () {
                          setMode(true);
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        constraints: BoxConstraints(maxWidth: 50),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.help),
                          label: const Text(''),
                          onPressed: () {
                            _showDialog(context);
                          },
                        ),
                      )*/
                  FloatingActionButton.small(
                    onPressed: () {
                      setMode(false);
                    },
                    child: const Icon(Icons.replay),
                  ),
                  const SizedBox(height: 20, width: 20),
                  FloatingActionButton.small(
                    onPressed: () {
                      _showDialog(context);
                    },
                    child: const Icon(Icons.help),
                  )
                ],
              ),
            )),
      ])));
}
