import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivities extends HomeEvent {
  const LoadActivities();

  @override
  List<Object?> get props => [];
}