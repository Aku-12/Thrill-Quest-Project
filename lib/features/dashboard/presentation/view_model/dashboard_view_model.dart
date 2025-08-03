import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_event.dart'; // Ensure correct path
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_state.dart'; // Ensure correct path

class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  final AuthService _authService;
  DashboardViewModel({required AuthService authService, required Null Function(dynamic context, dynamic route) navigate})
    : _authService = authService,
      super(const DashboardState()) {
    on<DashboardTabChanged>((event, emit) {
      emit(state.copyWith(currentIndex: event.tabIndex));
    });
    on<LogoutEvent>((event, emit) async {
      await _authService.signOut();
      if (event.context.mounted) {
        Navigator.pushReplacementNamed(event.context, '/login');
      }
    });
  }
}
