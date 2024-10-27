import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(DiceApp());

class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Roller App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  int _diceNumber1 = 0;
  int _diceNumber2 = 0;
  int _diceNumber3 = 0;
  int _diceNumber4 = 0;

  int _score1 = 0;
  int _score2 = 0;
  int _score3 = 0;
  int _score4 = 0;

  bool _isPlayer1Turn = true;
  bool _isPlayer2Turn = false;
  bool _isPlayer3Turn = false;
  bool _isPlayer4Turn = false;

  Color _player1ButtonColor = Colors.blue;
  Color _player2ButtonColor = Colors.blue;
  Color _player3ButtonColor = Colors.blue;
  Color _player4ButtonColor = Colors.blue;

  String _message = '';
  bool _gameOver = false; // Track whether the game is over

  void _checkWinner() {
    if (_score1 >= 30) {
      _message = 'Player 1 Wins!';
      _gameOver = true;
    } else if (_score2 >= 30) {
      _message = 'Player 2 Wins!';
      _gameOver = true;
    } else if (_score3 >= 30) {
      _message = 'Player 3 Wins!';
      _gameOver = true;
    } else if (_score4 >= 30) {
      _message = 'Player 4 Wins!';
      _gameOver = true;
    } else {
      _message = ''; // Reset if no one has reached 30 yet
    }
  }

  void _rollDice(int player) {
    if (_gameOver) return; // Disable rolling if the game is over
    int newDiceNumber = Random().nextInt(6) + 1;

    setState(() {
      if (player == 1) {
        _diceNumber1 = newDiceNumber;
        _score1 += newDiceNumber;
        _isPlayer1Turn = newDiceNumber == 6;
        _isPlayer2Turn = newDiceNumber != 6;
        _player1ButtonColor = newDiceNumber == 6 ? Colors.green : Colors.blue;
      } else if (player == 2) {
        _diceNumber2 = newDiceNumber;
        _score2 += newDiceNumber;
        _isPlayer2Turn = newDiceNumber == 6;
        _isPlayer3Turn = newDiceNumber != 6;
        _player2ButtonColor = newDiceNumber == 6 ? Colors.green : Colors.blue;
      } else if (player == 3) {
        _diceNumber3 = newDiceNumber;
        _score3 += newDiceNumber;
        _isPlayer3Turn = newDiceNumber == 6;
        _isPlayer4Turn = newDiceNumber != 6;
        _player3ButtonColor = newDiceNumber == 6 ? Colors.green : Colors.blue;
      } else if (player == 4) {
        _diceNumber4 = newDiceNumber;
        _score4 += newDiceNumber;
        _isPlayer4Turn = newDiceNumber == 6;
        _isPlayer1Turn = newDiceNumber != 6;
        _player4ButtonColor = newDiceNumber == 6 ? Colors.green : Colors.blue;
      }

      _checkWinner();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Dice Roller'),
        backgroundColor: Color(0xBEE0C066),
      ),
      backgroundColor: Color(0xBEE0C066),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display Scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreText('Player 1', _score1),
              _buildScoreText('Player 2', _score2),
              _buildScoreText('Player 3', _score3),
              _buildScoreText('Player 4', _score4),
            ],
          ),
          SizedBox(height: 50),

          // Display Winner or Failure message
          Text(
            _message,
            style: TextStyle(
              fontSize: 28,
              color: _message.contains('Wins') ? Colors.white : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDiceColumn(
                'Player 1: $_diceNumber1',
                _diceNumber1,
                _isPlayer1Turn,
                    () => _rollDice(1),
                _player1ButtonColor,
              ),
              SizedBox(width: 80),
              _buildDiceColumn(
                'Player 2: $_diceNumber2',
                _diceNumber2,
                _isPlayer2Turn,
                    () => _rollDice(2),
                _player2ButtonColor,
              ),
            ],
          ),
          SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDiceColumn(
                'Player 3: $_diceNumber3',
                _diceNumber3,
                _isPlayer3Turn,
                    () => _rollDice(3),
                _player3ButtonColor,
              ),
              SizedBox(width: 80),
              _buildDiceColumn(
                'Player 4: $_diceNumber4',
                _diceNumber4,
                _isPlayer4Turn,
                    () => _rollDice(4),
                _player4ButtonColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreText(String player, int score) {
    return Column(
      children: [
        Text(
          player,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'Score: $score',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildDiceColumn(String text, int diceNumber, bool isPlayerTurn, VoidCallback onPressed, Color buttonColor) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Image.asset(
            'images/dice-$diceNumber.png',
            key: ValueKey<int>(diceNumber), // Use key to trigger animation on change
            height: 100,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: isPlayerTurn && !_gameOver ? onPressed : null, // Disable button if not player's turn or game over
          child: Text(' Roll the Dice '),
          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
        ),
      ],
    );
  }
}