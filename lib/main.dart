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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Helvetica',
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
    resetGame(false);
  }

  void enter() {
    setState(() {
      if (!correct) {
        debugPrint("guess is $guess");
        if (game.validGuess(guess) && !correct) {
          String parsedGuess = game.parseGuess(guess);
          print(parsedGuess);
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
          print("Please enter valid guess");
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

  Widget keyBox(String c) {
    return Container(
        key: Key("btn_$c"),
        margin: const EdgeInsets.all(4.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            fixedSize: Size.fromHeight(50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            padding: const EdgeInsets.all(20.0),
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
            fixedSize: Size.fromHeight(50),
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
            fixedSize: Size.fromHeight(50),
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
    return Container(
        child: Column(
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
    ));
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
            if (event.isKeyPressed(LogicalKeyboardKey.keyA)) {
              letter('A');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyB)) {
              letter('B');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyC)) {
              letter('C');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyD)) {
              letter('D');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyE)) {
              letter('E');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyF)) {
              letter('F');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyG)) {
              letter('G');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyH)) {
              letter('H');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyI)) {
              letter('I');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyJ)) {
              letter('J');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyK)) {
              letter('K');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyL)) {
              letter('L');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyM)) {
              letter('M');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyN)) {
              letter('N');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyO)) {
              letter('O');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyP)) {
              letter('P');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyQ)) {
              letter('Q');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyR)) {
              letter('R');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyS)) {
              letter('S');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyT)) {
              letter('T');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyU)) {
              letter('U');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyV)) {
              letter('V');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyW)) {
              letter('W');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyX)) {
              letter('X');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyY)) {
              letter('Y');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.keyZ)) {
              letter('Z');
            }
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              enter();
            }
            if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
              delete();
            }

            setState(() => keys.add(key));
          }
        },
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endContained,
          /*appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),*/
          body: Center(
              child: Column(
            children: [
              const SizedBox(height: 50),
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 400,
                    maxWidth: 400,
                  ),
                  child: GridView.count(
                    primary: false,
                    //physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    // IF TIME: MAKE PADDING LESS FOR SMALLER SIZE (SCALE FOR SCREEN SCALE)
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
                ),
              ),
              const SizedBox(height: 70),
              Container(
                  constraints:
                      const BoxConstraints(minWidth: 500, maxWidth: 700),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < let1.length; i++) ...[
                            keyBox(let1[i]),
                          ]
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < let2.length; i++) ...[
                            keyBox(let2[i]),
                          ]
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          deleteButton(),
                          for (int i = 0; i < let3.length; i++) ...[
                            keyBox(let3[i]),
                          ],
                          enterButton(),
                        ])
                  ])),
            ],
          )),
          floatingActionButton: Container(
              child: Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text('Easy mode'),
                onPressed: () {
                  setMode(false);
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text('Hard mode'),
                onPressed: () {
                  setMode(true);
                },
              )
            ],
          )),
        ),
      );
}
