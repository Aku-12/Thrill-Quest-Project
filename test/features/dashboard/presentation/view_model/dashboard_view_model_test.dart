import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_view_model.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}
class MockBuildContext extends Mock implements BuildContext {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late DashboardViewModel dashboardViewModel;
  late MockAuthService mockAuthService;
  late MockBuildContext mockContext;

  setUp(() {
    mockAuthService = MockAuthService();
    mockContext = MockBuildContext();

    dashboardViewModel = DashboardViewModel(authService: mockAuthService, navigate: (context, route) {  });
  });

  group('DashboardViewModel', () {
    test('initial state has currentIndex 0', () {
      expect(dashboardViewModel.state.currentIndex, 0);
    });

    blocTest<DashboardViewModel, DashboardState>(
      'emits state with updated currentIndex when DashboardTabChanged is added',
      build: () => dashboardViewModel,
      act: (bloc) => bloc.add(const DashboardTabChanged(tabIndex: 2)),
      expect: () => [
        const DashboardState(currentIndex: 2),
      ],
    );

    blocTest<DashboardViewModel, DashboardState>(
      'does not navigate if context is not mounted on LogoutEvent',
      build: () => dashboardViewModel,
      setUp: () {
        when(() => mockAuthService.signOut()).thenAnswer((_) async {});
        when(() => mockContext.mounted).thenReturn(false);
      },
      act: (bloc) => bloc.add(LogoutEvent(context: mockContext)),
      verify: (_) async {
        verify(() => mockAuthService.signOut()).called(1);
        verify(() => mockContext.mounted).called(1);
        // Navigation should not be called here.
      },
    );
  });

  blocTest<DashboardViewModel, DashboardState>(
      'emits multiple states with different indices in sequence',
      build: () => dashboardViewModel,
      act: (bloc) {
        bloc.add(const DashboardTabChanged(tabIndex: 1));
        bloc.add(const DashboardTabChanged(tabIndex: 3));
      },
      expect: () => [
        const DashboardState(currentIndex: 1),
        const DashboardState(currentIndex: 3),
      ],
    );
}
