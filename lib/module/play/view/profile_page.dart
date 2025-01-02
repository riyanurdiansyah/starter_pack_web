import 'package:flutter/material.dart';

class HoverDropdownExample extends StatefulWidget {
  const HoverDropdownExample({super.key});

  @override
  _HoverDropdownExampleState createState() => _HoverDropdownExampleState();
}

class _HoverDropdownExampleState extends State<HoverDropdownExample> {
  final bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
              height: 150,
              width: 250,
              child: const SingleChildScrollView(
                child: Column(
                  children: [],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
