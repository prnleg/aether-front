import '../../domain/models/asset_model.dart';

class AssetDto {
  final String id;
  final String name;
  final double value;
  final String type;
  final double change24h;

  const AssetDto({
    required this.id,
    required this.name,
    required this.value,
    required this.type,
    required this.change24h,
  });

  factory AssetDto.fromJson(Map<String, dynamic> json) => AssetDto(
        id: json['id'] as String,
        name: json['name'] as String,
        value: (json['value'] as num).toDouble(),
        type: json['type'] as String,
        change24h: (json['change24h'] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'value': value,
        'type': type,
        'change24h': change24h,
      };

  // history, correlations, milestones are intentionally omitted — these are
  // mock-only fields. Real API DTOs will add them when the backend is ready.
  Asset toDomain() => Asset(
        id: id,
        name: name,
        value: value,
        type: AssetType.values.byName(type),
        change24h: change24h,
      );
}
