import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardTabChanged extends DashboardEvent {
  final int tabIndex;

  const DashboardTabChanged({required this.tabIndex});

  @override
  List<Object?> get props => [tabIndex];
}

class LogoutEvent extends DashboardEvent {
  final BuildContext context;

  const LogoutEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
