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
  bool _showFrame = true;

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
            curve: Curves.easeInOut,
          ),
          FramedImageAnimation(
            showFrame: _showFrame,
            onToggleFrame: (value) {
              setState(() {
                _showFrame = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final Duration duration;
  final Color textColor;
  final Curve? curve;

  const FadingTextAnimation({
    required this.duration,
    required this.textColor,
    this.curve,
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
          GestureDetector(
            onTap: toggleVisibility,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: widget.duration,
              curve: widget.curve ?? Curves.linear,
              child: const Text(
                'Hello, Flutter!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: toggleVisibility,
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(height: 20),
          Text(
            'Duration: ${widget.duration.inMilliseconds}ms',
            style: TextStyle(color: widget.textColor),
          ),
          const SizedBox(height: 40),
          const Text(
            'Swipe left or right to change animation',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class FramedImageAnimation extends StatelessWidget {
  final bool showFrame;
  final Function(bool) onToggleFrame;

  const FramedImageAnimation({
    required this.showFrame,
    required this.onToggleFrame,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: showFrame
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.blue,
                      width: 8,
                    ),
                  )
                : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(showFrame ? 12 : 0),
              child: Image.network(
                'https://picsum.photos/id/237/200/300',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / 
                            loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text('Could not load image', 
                      style: TextStyle(color: Colors.red)),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Show Frame'),
              Switch(
                value: showFrame,
                onChanged: onToggleFrame,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Swipe left or right to see more animations',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
