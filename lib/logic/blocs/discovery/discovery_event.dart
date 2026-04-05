import 'package:equatable/equatable.dart';

abstract class DiscoveryEvent extends Equatable {
  const DiscoveryEvent();

  @override
  List<Object?> get props => [];
}

class FetchDiscoveryAssets extends DiscoveryEvent {}

class SearchDiscoveryAssets extends DiscoveryEvent {
  final String query;

  const SearchDiscoveryAssets(this.query);

  @override
  List<Object?> get props => [query];
}
