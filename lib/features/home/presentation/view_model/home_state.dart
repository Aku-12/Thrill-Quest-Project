import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeState {
  final List<ActivityEntity> activities;

  const HomeLoaded( {required this.activities});

  @override
  List<Object?> get props => [activities];
}

class HomeError extends HomeState {
  final String message;

  const HomeError( {required this.message});

  @override
  List<Object?> get props => [message];
}
