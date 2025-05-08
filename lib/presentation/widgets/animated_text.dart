import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final bool repeat;
  
  const AnimatedText({
    Key? key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
    this.repeat = false,
  }) : super(key: key);

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  String _displayText = '';
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _animation = Tween<double>(
      begin: 0,
      end: widget.text.length.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {
          _displayText = widget.text.substring(0, _animation.value.toInt());
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.repeat) {
          _controller.reset();
          _controller.forward();
        }
      });
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
    );
  }
}
