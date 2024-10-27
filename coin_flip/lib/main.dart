import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CoinFlipApp());
}

class CoinFlipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Flip',
      theme: ThemeData(
        primarySwatch: Colors.pink, // Updated primary color to pink
      ),
      home: CoinFlipScreen(),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String coinFace = 'Imagess/front.png'; // Initial image
  String resultText = ''; // To display heads or tails
  int score = 0; // Score variable
  String selectedSide = ''; // Store user's selection
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800), // Total duration of the flip (faster)
      vsync: this,
    );

    // Animation for flipping the coin
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine, // Smooth acceleration
      ),
    );
  }

  void flipCoin() {
    _controller.forward(from: 0).then((_) {
      // Determine the result after the animation
      setState(() {
        // Determine the final coin face and score based on the user's selection
        if (selectedSide == 'Heads') {
          coinFace = 'Imagess/front.png'; // Show front side for Heads
          resultText = 'Heads'; // Display result as Heads
          score = 1; // Set score to 1 for Heads
        } else if (selectedSide == 'Tails') {
          coinFace = 'Imagess/back.png'; // Show back side for Tails
          resultText = 'Tails'; // Display result as Tails
          score = 0; // Set score to 0 for Tails
        }
      });
      _controller.reverse(); // Reverse animation to bring the coin down
    });
  }

  void tossCoin() {
    // Flip the coin
    flipCoin();
  }

  void updateSelection(String side) {
    setState(() {
      selectedSide = side; // Update selected side
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Coin Flip',
            style: TextStyle(
              color: Colors.white, // White color for the title to match the theme
              fontSize: 24, // Adjusted size
              fontWeight: FontWeight.bold, // Bold title
            ),
          ),
        ),
        backgroundColor: Colors.pinkAccent, // Match AppBar color with theme
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pinkAccent.shade100, Colors.blue.shade100], // Gradient for background
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: flipCoin,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..translate(0.0, -250 * _animation.value) // Move the coin up higher
                        ..rotateY(pi * 2 * _animation.value), // Full rotation around Y-axis
                      alignment: FractionalOffset.center,
                      child: Image.asset(coinFace, width: 200, height: 200),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                resultText,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Accent color for result text
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Score: $score', // Display score
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent, // Accent color for score
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => updateSelection('Heads'), // Update selection for Heads
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSide == 'Heads' ? Colors.blue : Colors.pinkAccent, // Change color based on selection
                    ),
                    child: Text('Heads'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => updateSelection('Tails'), // Update selection for Tails
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSide == 'Tails' ? Colors.blue : Colors.pinkAccent, // Change color based on selection
                    ),
                    child: Text('Tails'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: tossCoin, // Toss the coin
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Match button color with the theme
                ),
                child: Text('Toss Coin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}