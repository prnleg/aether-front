import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AssetType {
  crypto,
  inventory,
  collectible,
  cash,
  stock,
}

class HistoryPoint extends Equatable {
  final DateTime date;
  final double value;

  const HistoryPoint({required this.date, required this.value});

  factory HistoryPoint.fromJson(Map<String, dynamic> json) => HistoryPoint(
        date: DateTime.parse(json['date'] as String),
        value: (json['value'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'value': value,
      };

  @override
  List<Object?> get props => [date, value];
}

class AssetCorrelation extends Equatable {
  final String name;
  final double value;

  const AssetCorrelation({required this.name, required this.value});

  factory AssetCorrelation.fromJson(Map<String, dynamic> json) => AssetCorrelation(
        name: json['name'] as String,
        value: (json['value'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };

  @override
  List<Object?> get props => [name, value];
}

class AssetMilestone extends Equatable {
  final String date;
  final String event;
  final String price;
  final IconData icon;

  const AssetMilestone({required this.date, required this.event, required this.price, required this.icon});

  @override
  List<Object?> get props => [date, event, price, icon];
}

class Asset extends Equatable {
  final String id;
  final String name;
  final double value;
  final AssetType type;
  final double change24h; // Percentage change in the last 24h
  final List<HistoryPoint> history;
  final List<AssetCorrelation> correlations;
  final List<AssetMilestone> milestones;

  const Asset({
    required this.id,
    required this.name,
    required this.value,
    required this.type,
    this.change24h = 0.0,
    this.history = const [],
    this.correlations = const [],
    this.milestones = const [],
  });

  Asset copyWith({
    String? id,
    String? name,
    double? value,
    AssetType? type,
    double? change24h,
    List<HistoryPoint>? history,
    List<AssetCorrelation>? correlations,
    List<AssetMilestone>? milestones,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      type: type ?? this.type,
      change24h: change24h ?? this.change24h,
      history: history ?? this.history,
      correlations: correlations ?? this.correlations,
      milestones: milestones ?? this.milestones,
    );
  }

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        id: json['id'] as String,
        name: json['name'] as String,
        value: (json['value'] as num).toDouble(),
        type: AssetType.values.byName(json['type'] as String),
        change24h: (json['change24h'] as num?)?.toDouble() ?? 0.0,
        history: (json['history'] as List<dynamic>?)
                ?.map((e) => HistoryPoint.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'value': value,
        'type': type.name,
        'change24h': change24h,
        'history': history.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, name, value, type, change24h, history, correlations, milestones];

  String get typeName {
    switch (type) {
      case AssetType.crypto:
        return 'Crypto';
      case AssetType.inventory:
        return 'Inventory';
      case AssetType.collectible:
        return 'Collectible';
      case AssetType.cash:
        return 'Cash';
      case AssetType.stock:
        return 'Stock';
    }
  }
}
