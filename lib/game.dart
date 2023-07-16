//import 'dart:async';
import 'dart:math';

import 'AllBirdList.dart';
import 'AllGuessList.dart';
import 'FiveLetterBirds.dart';
import 'FiveLetterGuesses.dart';

class Game {
  late String _word;
  late List<String> _birds;
  late List<String> _guessList;
  late List _letterData = [];

  // ignore: unused_field
  late bool _correct;

  Game() {
    _correct = false;
    _birds = [];
    _guessList = [];
  }

  void loadMode(bool hardMode) {
    if (hardMode) {
      _birds = AllBirdList.allBirdList;
      _guessList = AllGuessList.allGuessList;
    } else {
      _birds = FiveLetterBirds.fiveLetterBirds;
      _guessList = FiveLetterGuesses.fiveLetterGuesses;
    }
    _word = _chooseBird();
    _word = _word.toUpperCase();
    print(_word);
    print("${_word.length} characters");
    _letterData = List<String>.filled(26, "-");
  }

  String _chooseBird() {
    int i = Random().nextInt(_birds.length - 1);
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
