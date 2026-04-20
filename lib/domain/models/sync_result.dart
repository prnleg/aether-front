import 'package:equatable/equatable.dart';

class SyncResult extends Equatable {
  final int added;
  final int updated;
  final int skipped;

  const SyncResult({
    required this.added,
    required this.updated,
    required this.skipped,
  });

  @override
  List<Object?> get props => [added, updated, skipped];
}
