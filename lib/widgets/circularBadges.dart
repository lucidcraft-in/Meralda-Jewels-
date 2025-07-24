import 'package:flutter/material.dart';

class Circularbadges extends StatefulWidget {
  Circularbadges({super.key, required this.gram, required this.amount});
  String gram;
  double amount;

  @override
  State<Circularbadges> createState() => _CircularbadgesState();
}

class _CircularbadgesState extends State<Circularbadges> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Scale base font size relative to screen width
    double scale(double size) =>
        size * screenWidth / 375; // 375 is base iPhone width

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular badge with gram indicator
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF2D5A5A),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.gram,
                  style: TextStyle(
                    fontSize: scale(13),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Gram',
                  style: TextStyle(
                    fontSize: scale(10),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Price display
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.amount.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: scale(16),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
