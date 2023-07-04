//import 'dart:io';
import 'package:universal_io/io.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

class Game {
  late String _word;
  late List<String> _birds;
  late List<String> _guessList;
  late List _letterData = [];

  // ignore: unused_field
  late bool _correct;

  Game(String mode) {
    _correct = false;
    _birds = [];
    _guessList = [];
    String pathname = "/home/divya/flutter/birdle_v2/lib/FiveLetterBirds.txt";
    String guessPathname =
        "/home/divya/flutter/birdle_v2/lib/FiveLetterGuesses.txt";
    if (mode == "hard") {
      pathname = "/home/divya/flutter/birdle_v2/lib/AllBirdList.txt";
      guessPathname = "/home/divya/flutter/birdle_v2/lib/AllGuessList.txt";
    }
    //print(pathname);
    _birds = _readBirds(pathname, _birds);
    _guessList = _readBirds(guessPathname, _guessList);
    //print(_birds.length);
    _word = _chooseBird();
    //_word = "xexxx";
    _word = _word.toUpperCase();
    print(_word);
    print("${_word.length} characters");
    _letterData = List<String>.filled(26, "-");
    //print(parseGuess("EXEXE"));
    //print(parseGuess("XEXXX"));
  }

  Future<void> _readBirdsAsync(String pathname, var destination) async {
    final file = File(pathname);
    Stream<String> lines = file
        .openRead()
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(LineSplitter()); // Convert stream to individual lines.
    try {
      await for (var line in lines) {
        //print('$pathname:   $line: ${line.length} characters');
        destination.add(line);
      }
      print('File is now closed.');
    } catch (e) {
      print('Error: $e');
    }
    for (String s in _birds) {
      print("Birds has:   $s");
    }
    for (String s in _guessList) {
      print("GuessList has:   $s");
    }
  }

  List<String> _readBirds(String pathname, List<String> destination) {
    final file = File(pathname);
    destination = file.readAsLinesSync();
    //destination.forEach((l) => print("2: $pathname:     $l"));
    return destination;
  }

  String _chooseBird() {
    print("length is ${_birds.length}");
    int i = Random().nextInt(_birds.length - 1);
    print('***************i is $i');
    return _birds[i];
  }

  String getWord() {
    return _word;
  }

  List getLetterData() {
    return _letterData;
  }

  String parseGuess(String guess) {
    var result = List<String>.filled(_word.length, "-");
    var tempWord = List<String>.filled(_word.length, "-");
    for (int i = 0; i < _word.length; i++) {
      tempWord[i] = _word[i].toUpperCase();
    }
    for (int i = 0; i < _word.length; i++) {
      result[i] = 'O';
    }
    for (int i = 0; i < tempWord.length; i++) {
      print(tempWord[i]);
    } //debug
    for (int i = 0; i < tempWord.length; i++) {
      if (tempWord[i] == guess[i].toUpperCase()) {
        result[i] = 'G';
        tempWord[i] = '.';
      }
    }
    for (int i = 0; i < tempWord.length; i++) {
      if (result[i] != 'G') {
        for (int v = 0; v < tempWord.length; v++) {
          if (tempWord[v] == guess[i]) {
            result[i] = 'Y';
            tempWord[v] = '.';
          }
        }
      }
    }
    String resultString = "";
    _correct = true;
    for (int i = 0; i < result.length; i++) {
      resultString += result[i];
      if (result[i] != 'G') {
        _correct = false;
      }
      String current = _letterData[guess.codeUnitAt(i) - 65];
      if (result[i] == 'G') {
        _letterData[guess.codeUnitAt(i) - 65] = result[i];
      } else if (result[i] == 'Y') {
        if (current != 'G') {
          _letterData[guess.codeUnitAt(i) - 65] = result[i];
        }
      } else if (result[i] == 'O') {
        if (current != 'G' && current != 'Y') {
          _letterData[guess.codeUnitAt(i) - 65] = result[i];
        }
      }
    }
    return resultString;
  }

  bool validGuess(String guess) {
    bool valid = true;
    if (!_guessList.contains(guess.toLowerCase())) {
      print("not in bird list");
      valid = false;
    }
    if (guess.length != _word.length) {
      print("length does not match");
      valid = false;
    }
    return valid;
  }

  bool isCorrect(String parsedGuess) {
    for (int i = 0; i < parsedGuess.length; i++) {
      if (parsedGuess[i] != 'G') {
        return false;
      }
    }
    return true;
  }
}
