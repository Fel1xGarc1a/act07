import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: AnimationScreens(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

class AnimationScreens extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  AnimationScreens({required this.toggleTheme, required this.isDarkMode});

  @override
  _AnimationScreensState createState() => _AnimationScreensState();
}

class _AnimationScreensState extends State<AnimationScreens> {
  PageController _pageController = PageController();
  Color _textColor = Colors.black;

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (Color color) {
                setState(() {
                  _textColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Animations'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => widget.toggleTheme(),
          ),
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: _showColorPicker,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          FadingTextAnimation(
            duration: Duration(seconds: 1),
            textColor: _textColor,
          ),
          FadingTextAnimation(
            duration: Duration(milliseconds: 500),
            textColor: _textColor,
          ),
        ],
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final Duration duration;
  final Color textColor;

  FadingTextAnimation({
    required this.duration,
    required this.textColor,
  });

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: widget.duration,
            child: Text(
              'Hello, Flutter!',
              style: TextStyle(fontSize: 24, color: widget.textColor),
            ),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: toggleVisibility,
            child: Icon(Icons.play_arrow),
          ),
          SizedBox(height: 20),
          Text(
            'Duration: ${widget.duration.inMilliseconds}ms',
            style: TextStyle(color: widget.textColor),
          ),
          SizedBox(height: 40),
          Text('Swipe left or right to change animation duration',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
