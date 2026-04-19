import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Returns the icon for a market asset based on its [type] string.
/// This mapping belongs in the presentation layer, not in the domain model.
IconData marketAssetIcon(String type) {
  switch (type.toLowerCase()) {
    case 'crypto':
      return FontAwesomeIcons.ethereum;
    case 'cs:go skin':
    case 'csgo skin':
      return FontAwesomeIcons.gun;
    case 'nft':
      return Icons.auto_awesome;
    case 'stock':
      return Icons.trending_up;
    default:
      return Icons.show_chart;
  }
}
