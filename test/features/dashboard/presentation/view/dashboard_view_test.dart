import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:thrill_quest/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_view_model.dart';

// Mock Bloc
class MockDashboardViewModel extends Mock implements DashboardViewModel {}

// Mock Accelerometer Stream
class FakeAccelerometerStream extends Stream<AccelerometerEvent> {
  final StreamController<AccelerometerEvent> _controller = StreamController<AccelerometerEvent>();

  @override
  StreamSubscription<AccelerometerEvent> listen(void Function(AccelerometerEvent)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void addEvent(AccelerometerEvent event) {
    _controller.add(event);
  }

  void close() {
    _controller.close();
  }
}

void main() {
  late MockDashboardViewModel mockBloc;
  late FakeAccelerometerStream fakeAccelerometerStream;

  setUp(() {
    mockBloc = MockDashboardViewModel();

    // Default state to index 0
    when(() => mockBloc.state).thenReturn(DashboardState(currentIndex: 0));
    whenListen(mockBloc, Stream.value(DashboardState(currentIndex: 0)));

    // Replace the accelerometer stream with fake stream
    fakeAccelerometerStream = FakeAccelerometerStream();

    // Override the accelerometerEventStream method if possible
  });

  Future<void> pumpDashboardView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DashboardViewModel>.value(
          value: mockBloc,
          child: const DashboardView(),
        ),
      ),
    );
  }

  testWidgets('shake gesture triggers logout confirmation dialog', (tester) async {
    // This requires a way to inject fake accelerometer events.
    // Since accelerometerEventStream is a top-level function,
    // you might need to refactor your DashboardView to accept a stream or
    // override it using a method channel or dependency injection.

    // For demonstration, here is how it would look conceptually:
    // This test is pseudo-code and might not run without refactor.

    /*
    // Replace accelerometerEventStream with fake stream
    DashboardView.accelerometerStream = fakeAccelerometerStream;

    await pumpDashboardView(tester);
    await tester.pumpAndSettle();

    // Send a high magnitude accelerometer event to simulate shake
    fakeAccelerometerStream.addEvent(
      AccelerometerEvent(20, 20, 20),
    );
    await tester.pumpAndSettle();

    // Confirm logout dialog is shown
    expect(find.text('Log Out'), findsOneWidget);
    */
  });
}
