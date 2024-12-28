import 'package:flutter/material.dart';

class ScrollingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double width;

  const ScrollingText({
    Key? key,
    required this.text,
    required this.style,
    required this.width,
  }) : super(key: key);

  @override
  State<ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  bool _showScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.position.maxScrollExtent > 0) {
        setState(() => _showScroll = true);
        _startScrolling();
      }
    });
  }

  void _startScrolling() async {
    while (_showScroll) {
      await Future.delayed(const Duration(seconds: 2));
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
        );
        await Future.delayed(const Duration(seconds: 1));
        await _scrollController.animateTo(
          0.0,
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _showScroll = false;
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Text(
          widget.text,
          style: widget.style,
        ),
      ),
    );
  }
}
