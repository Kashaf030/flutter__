import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: OnboardingScreen(), // Start with the onboarding screen
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 1);
            },
            children: [
              buildPage(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image: 'assets/images/girl.png',
                title: 'Welcome to Xylophone App',
                subtitle: 'Enjoy music with ease!',
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              buildPage(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade300, Colors.teal.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image: 'assets/images/b.png',
                title: 'Learn to Play',
                subtitle: 'Practice makes perfect!',
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.1,
            left: 16,
            right: 16,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 2,
                effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 16,
                  activeDotColor: Colors.deepPurple,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            right: 16,
            child: isLastPage
                ? ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CustomizeXylophoneScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              child: Text('Start', style: TextStyle(color: Colors.white)),
            )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required LinearGradient gradient,
    required String image,
    required String title,
    required String subtitle,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: CustomPaint(
        painter: DiamondPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: screenWidth * 0.7, height: screenHeight * 0.35),
            SizedBox(height: screenHeight * 0.04),
            Text(
              title,
              style: TextStyle(fontSize: screenHeight * 0.03, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: screenHeight * 0.025, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class DiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final Path path = Path();

    // Draw diamonds
    for (double x = 0; x < size.width; x += 100) {
      for (double y = 0; y < size.height; y += 100) {
        path.moveTo(x + 50, y); // Top
        path.lineTo(x, y + 50); // Left
        path.lineTo(x + 50, y + 100); // Bottom
        path.lineTo(x + 100, y + 50); // Right
        path.close();
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint
  }
}

class CustomizeXylophoneScreen extends StatefulWidget {
  @override
  _CustomizeXylophoneScreenState createState() => _CustomizeXylophoneScreenState();
}

class _CustomizeXylophoneScreenState extends State<CustomizeXylophoneScreen> {
  final AudioCache audioCache = AudioCache(prefix: 'assets/sounds/');

  // Initial default colors for each key
  List<Color> keyColors = [
    Colors.redAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  // Initial default sounds for each key
  List<int> keySounds = [1, 2, 3, 4, 5, 6, 7];

  @override
  void initState() {
    super.initState();
    preloadSounds();
  }

  // Preload the sound files
  void preloadSounds() {
    for (var i = 1; i <= 7; i++) {
      audioCache.load('note$i.wav');
    }
  }

  // Play the selected sound
  void playSound(int soundNumber) {
    audioCache.play('note$soundNumber.wav');
  }

  // Play all sounds sequentially
  void playAllSounds() async {
    for (var i = 1; i <= 7; i++) {
      await audioCache.play('note$i.wav');
      await Future.delayed(Duration(milliseconds: 500)); // Delay between sounds
    }
  }

  // Dialog to pick color and sound for a key
  void customizeKey(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color selectedColor = keyColors[index];
        int selectedSound = keySounds[index];

        return AlertDialog(
          title: Text('Customize Key ${index + 1}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Color:'),
              // Color Picker
              BlockPicker(
                pickerColor: keyColors[index],
                onColorChanged: (Color color) {
                  selectedColor = color;
                },
              ),
              SizedBox(height: 20),
              Text('Select Sound:'),
              // Sound picker (dropdown for selecting sound)
              DropdownButton<int>(
                value: selectedSound,
                items: List.generate(7, (i) => i + 1).map((sound) {
                  return DropdownMenuItem(
                    child: Text('Sound $sound'),
                    value: sound,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSound = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  keyColors[index] = selectedColor;
                  keySounds[index] = selectedSound;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Build each xylophone key with a circle behind it
  Widget buildKeyWithCircle(Color color, int sound, int index) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Circle behind the key
        Positioned(
          left: 0, // Align the circle to the left
          child: Container(
            width: 60, // Diameter of the circle, equal to the height of the key
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.5), // Lighter shade of the key's color
            ),
          ),
        ),
        // Key on top of the circle
        GestureDetector(
          onTapDown: (_) {
            playSound(sound);
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.08, // Height of each key
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.only(left: 70), // Add padding to accommodate the circle
            child: Center(
              child: Text(
                'Sound $sound',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Build the side menu for key customization
  Widget buildSideMenu() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      color: Colors.deepPurple.shade100.withOpacity(0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(7, (index) {
          return IconButton(
            icon: Icon(Icons.color_lens, color: keyColors[index]),
            onPressed: () {
              customizeKey(index);
            },
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Xylophone'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent.shade100, Colors.pink.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          CustomPaint(
            painter: DiamondPainter(), // Draw diamond background
            child: Row(
              children: [
                buildSideMenu(), // Side menu for keys customization
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(keyColors.length, (index) {
                      return buildKeyWithCircle(keyColors[index], keySounds[index], index);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: playAllSounds,
        child: Icon(Icons.play_arrow),
        backgroundColor: Colors.deepPurple.shade400,
      ),
    );
  }
}