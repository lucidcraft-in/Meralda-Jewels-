import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  CategoryItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/necklace.png')),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
