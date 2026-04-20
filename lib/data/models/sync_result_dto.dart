import '../../domain/models/sync_result.dart';

class SyncResultDto {
  final int added;
  final int updated;
  final int skipped;

  const SyncResultDto({
    required this.added,
    required this.updated,
    required this.skipped,
  });

  factory SyncResultDto.fromJson(Map<String, dynamic> json) => SyncResultDto(
        added: (json['added'] ?? json['Added'] ?? 0) as int,
        updated: (json['updated'] ?? json['Updated'] ?? 0) as int,
        skipped: (json['skipped'] ?? json['Skipped'] ?? 0) as int,
      );

  SyncResult toDomain() => SyncResult(
        added: added,
        updated: updated,
        skipped: skipped,
      );
}
