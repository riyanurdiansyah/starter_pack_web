import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: GoogleFonts.nanumGothicCoding(
              fontSize: 18, // Ukuran font berubah saat hover
              height: 2.5,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            child: Text(title),
          ),
        ],
      ),
    );
  }
}
