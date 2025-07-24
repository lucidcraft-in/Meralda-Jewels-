import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final Map<String, IconData> categoryIcons = {
  'rings': Icons.circle,
  'necklaces': FontAwesomeIcons.gem,
  'earrings': FontAwesomeIcons.earListen,
  'bracelets': FontAwesomeIcons.handHoldingHeart,
  'pendants': FontAwesomeIcons.medal,
  'chains': FontAwesomeIcons.link,
  'anklets': FontAwesomeIcons.shoePrints,
  'bangles': FontAwesomeIcons.infinity,
  'nose pins': FontAwesomeIcons.dotCircle,
  'toe rings': FontAwesomeIcons.ring,
  'lockets': FontAwesomeIcons.lock,
  'watches': FontAwesomeIcons.clock,
  'sets': FontAwesomeIcons.layerGroup,
  'brooches': FontAwesomeIcons.star,
  'cufflinks': FontAwesomeIcons.gripLines,
  'charms': FontAwesomeIcons.magic,
  'tiaras': FontAwesomeIcons.crown,
  'jewelry boxes': FontAwesomeIcons.boxOpen,
  'accessories': FontAwesomeIcons.puzzlePiece,
};

List<Map<String, dynamic>> convertCategories(
    List<Map<String, dynamic>> backendData) {
  return backendData.map((category) {
    String normalized = normalizeName(category['name']);

    // Find matching key from map
    String? matchedKey = categoryIcons.keys.firstWhere(
      (key) => normalized.contains(key),
      orElse: () => '',
    );

    return {
      'name': category['name'],
      'icon': categoryIcons[matchedKey] ?? Icons.category, // fallback icon
    };
  }).toList();
}

String normalizeName(String rawName) {
  return rawName.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
}
