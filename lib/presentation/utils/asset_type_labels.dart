import 'package:aether/l10n/app_localizations.dart';
import '../../domain/models/asset_model.dart';

/// Returns the localized display name for an [AssetType].
/// Use this in the presentation layer instead of Asset.typeName.
String assetTypeLabel(AssetType type, AppLocalizations l10n) {
  switch (type) {
    case AssetType.crypto:
      return l10n.crypto;
    case AssetType.inventory:
      return l10n.inventory;
    case AssetType.collectible:
      return l10n.collectible;
    case AssetType.cash:
      return l10n.cash;
    case AssetType.stock:
      return l10n.stock;
  }
}
