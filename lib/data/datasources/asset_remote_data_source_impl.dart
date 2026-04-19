import '../../domain/models/asset_model.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/network/api_client.dart';
import '../../core/services/token_storage.dart';
import '../models/portfolio_dto.dart';
import 'asset_remote_data_source.dart';

class AssetRemoteDataSourceImpl implements AssetRemoteDataSource {
  final ApiClient _api;
  final TokenStorage _tokenStorage;

  AssetRemoteDataSourceImpl(this._api, this._tokenStorage);

  @override
  Future<List<Asset>> getAssets() async {
    final portfolioId = _tokenStorage.readPortfolioId();
    if (portfolioId == null) return [];

    try {
      final response = await _api.get('/api/portfolio/$portfolioId');
      final portfolio =
          PortfolioDto.fromJson(response.data as Map<String, dynamic>);
      return portfolio.assets.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      // 404 = portfolio not yet created (new user). Return empty list so the
      // dashboard loads cleanly instead of showing an error.
      return [];
    }
  }

  @override
  Future<void> deleteAsset(String assetId) async {
    final portfolioId = _tokenStorage.readPortfolioId();
    if (portfolioId == null) throw const AuthException('Not authenticated');
    await _api.delete('/api/portfolio/$portfolioId/assets/$assetId');
  }

  @override
  Future<void> addAsset(Asset asset) async {
    final portfolioId = _tokenStorage.readPortfolioId();
    if (portfolioId == null) throw const AuthException('Not authenticated');

    final endpoint = _endpointFor(asset.type);
    final body = _buildBody(asset);
    await _api.post('/api/portfolio/$portfolioId/assets/$endpoint', data: body);
  }

  String _endpointFor(AssetType type) {
    switch (type) {
      case AssetType.crypto:
        return 'crypto';
      case AssetType.inventory:
        return 'steam';
      case AssetType.collectible:
      case AssetType.stock:
      case AssetType.cash:
        return 'physical';
    }
  }

  Map<String, dynamic> _buildBody(Asset asset) {
    switch (asset.type) {
      case AssetType.crypto:
        return {
          'name': asset.name,
          'symbol': asset.symbol ?? asset.name,
          'quantity': asset.quantity ?? 1.0,
          'acquisitionPrice': asset.value,
          'currency': asset.currency,
        };
      case AssetType.inventory:
        return {
          'name': asset.name,
          'marketHashName': asset.marketHashName ?? asset.name,
          'acquisitionPrice': asset.value,
          'currency': asset.currency,
        };
      case AssetType.collectible:
      case AssetType.stock:
      case AssetType.cash:
        return {
          'name': asset.name,
          'category': asset.category ?? 'Other',
          'brand': asset.brand ?? '',
          'condition': asset.condition ?? 'Good',
          'acquisitionPrice': asset.value,
          'currency': asset.currency,
        };
    }
  }
}
