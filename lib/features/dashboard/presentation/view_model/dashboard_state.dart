import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class DashboardState extends Equatable {
  final int currentIndex;

  const DashboardState({this.currentIndex = 0});

  DashboardState copyWith({
    int? currentIndex,
  }) {
    return DashboardState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [currentIndex];
}