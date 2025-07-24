import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMoreInfo extends StatelessWidget {
  ProfileMoreInfo({super.key, required this.label, required this.icon});
  String label;
  final icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .05,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: 20,
              ),
            ),
            SizedBox(width: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textStyle: TextStyle(
                      color: Color.fromARGB(255, 140, 140, 140),
                      letterSpacing: .5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
