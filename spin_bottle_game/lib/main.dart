import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SpinBottleApp());
}

class SpinBottleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin the Bottle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpinBottleHomePage(),
    );
  }
}

class SpinBottleHomePage extends StatefulWidget {
  @override
  _SpinBottleHomePageState createState() => _SpinBottleHomePageState();
}

class _SpinBottleHomePageState extends State<SpinBottleHomePage>
    with SingleTickerProviderStateMixin {
  double _currentRotation = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isSpinning = false;
  String _selectedPlayer = '';
  String? _selectedBottle;
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _customChallengeController = TextEditingController();

  // List of 10 players (initial empty names)
  final List<String> _sections = [
    "Player 1",
    "Player 2",
    "Player 3",
    "Player 4",
    "Player 5",
    "Player 6",
    "Player 7",
    "Player 8",
    "Player 9",
    "Player 10",
  ];

  // List of bottle choices (actual image paths)
  final List<String> _bottleChoices = [
    'Images/bottle4.png',
    'Images/bottle5.png',
    'Images/bottle6.png',
    'Images/bottle7.png',
    'Images/bottle8.png',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          _currentRotation = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _playerNameController.dispose();
    _customChallengeController.dispose();
    super.dispose();
  }

  void _spinWheel() {
    setState(() {
      _isSpinning = true;
      _selectedPlayer = ''; // Clear the selected player initially
    });

    final random = Random();
    final double endRotation = random.nextDouble() * 10 * pi; // Spin for random rounds

    _animation = Tween<double>(begin: _currentRotation, end: _currentRotation + endRotation)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0).then((_) {
      setState(() {
        _isSpinning = false;
        _determineSelectedPlayer(endRotation); // Determine which player is selected
      });

      // Show the challenge message dialog
      _showChallengeDialog(_selectedPlayer);
    });
  }

  void _determineSelectedPlayer(double endRotation) {
    final totalRotation = (_currentRotation + endRotation) % (2 * pi);
    final anglePerSection = (2 * pi) / _sections.length;
    final selectedSectionIndex = (_sections.length - (totalRotation / anglePerSection).floor()) % _sections.length;

    setState(() {
      _selectedPlayer = _sections[selectedSectionIndex.toInt()];
    });
  }

  void _selectBottle() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Bottle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _bottleChoices.map((bottle) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedBottle = bottle;
                  });
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(bottle, width: 50, height: 50), // Display bottle image here
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  bool _isReadyToSpin() {
    return _selectedBottle != null &&
        _playerNameController.text.isNotEmpty &&
        _playerNameController.text.split(',').length == _sections.length;
  }

  void _showPlayerInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Player Names'),
          content: TextField(
            controller: _playerNameController,
            decoration: InputDecoration(hintText: "Enter 10 player names separated by commas"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  List<String> names = _playerNameController.text.split(',');
                  for (int i = 0; i < _sections.length && i < names.length; i++) {
                    _sections[i] = names[i].trim();
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showChallengeDialog(String playerName) {
    final challengeMessage = _getChallengeMessage(playerName);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Challenge for $playerName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(challengeMessage),
              TextField(
                controller: _customChallengeController,
                decoration: InputDecoration(hintText: "Enter your custom challenge"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final customChallenge = _customChallengeController.text.trim();
                if (customChallenge.isNotEmpty) {
                  _showCustomChallengeDialog(customChallenge);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add Custom Challenge'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCustomChallengeDialog(String customChallenge) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Custom Challenge'),
          content: Text(customChallenge),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getChallengeMessage(String playerName) {
    // List of challenges
    final List<String> challenges = [
      'do 10 push-ups!',
      'sing a song!',
      'dance for 30 seconds!',
      'tell a funny joke!',
      'do a handstand!',
      'act like your favorite movie character!'
    ];

    // Select a random challenge from the list
    final random = Random();
    String selectedChallenge = challenges[random.nextInt(challenges.length)];

    return '$playerName, it\'s your turn! Your challenge is to $selectedChallenge';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3F51B5), // Set a nice color for the AppBar
        centerTitle: true, // Center the title
        title: Text(
          'Spin the Bottle Game',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white, // Set a nice color for the title text
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEA95AB),
              Color(0xFFAEEAD0),
              Color(0xFFFFF7AE),
              Color(0xFFA3DAF1),
              Color(0xFFC4C4F1),
              Color(0xFFFFCC80),
              Color(0xFFEA8993),
            ], // Beautiful gradient background
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Selected Bottle:',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 10),
              _selectedBottle != null
                  ? Image.asset(_selectedBottle!, width: 100, height: 100)
                  : Text('No bottle selected', style: TextStyle(fontSize: 16, color: Colors.black)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectBottle,
                child: Text('Select Bottle'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showPlayerInputDialog,
                child: Text('Enter Player Names'),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(300, 300),
                      painter: WheelPainter(_sections),
                    ),
                    Transform.rotate(
                      angle: _currentRotation,
                      child: _selectedBottle != null
                          ? Image.asset(_selectedBottle!, width: 100, height: 100)
                          : Container(), // Show selected bottle or an empty container
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSpinning || !_isReadyToSpin() ? null : _spinWheel,
                child: Text(_isSpinning ? 'Spinning...' : 'Spin the Bottle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<String> sections;

  WheelPainter(this.sections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final anglePerSection = 2 * pi / sections.length;

    for (int i = 0; i < sections.length; i++) {
      paint.color = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0); // Random color for each section
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), i * anglePerSection, anglePerSection, true, paint);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), i * anglePerSection, anglePerSection, true, borderPaint);
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: 16,
      );
      final textSpan = TextSpan(
        text: sections[i],
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      final xCenter = center.dx + (radius / 2) * cos(anglePerSection * i + anglePerSection / 2);
      final yCenter = center.dy + (radius / 2) * sin(anglePerSection * i + anglePerSection / 2);
      textPainter.paint(
        canvas,
        Offset(xCenter - textPainter.width / 2, yCenter - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}