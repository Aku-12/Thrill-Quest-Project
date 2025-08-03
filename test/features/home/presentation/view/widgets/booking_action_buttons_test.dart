import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_event.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_state.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';
import 'package:thrill_quest/features/home/presentation/view/widgets/booking_action_buttons.dart';

class MockBookingViewModel extends Mock implements BookingViewModel {}

void main() {
  late BookingViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockBookingViewModel();
  });

  Widget createWidgetWithState(BookingState state) {
    when(() => mockViewModel.state).thenReturn(state);
    when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());

    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<BookingViewModel>.value(
          value: mockViewModel,
          child: BookingActionButtons(adventureTitle: 'Paragliding'),
        ),
      ),
    );
  }

  testWidgets('Calls Navigator.pop when Cancel is pressed', (tester) async {
    final state = BookingState();

    await tester.pumpWidget(createWidgetWithState(state));

    final navigator = Navigator.of(tester.element(find.byType(BookingActionButtons)));

    // Push a dummy route so we can pop it later
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => BlocProvider<BookingViewModel>.value(
                    value: mockViewModel,
                    child: BookingActionButtons(adventureTitle: 'Paragliding'),
                  ),
                );
              },
              child: const Text('Open Sheet'),
            ),
          );
        },
      ),
    ));

    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Cancel'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Bottom sheet should be dismissed
    expect(find.text('Cancel'), findsNothing);
  });

  testWidgets('Dispatches SubmitBooking event on complete button press', (tester) async {
    final state = BookingState(isLoading: false);

    await tester.pumpWidget(createWidgetWithState(state));

    await tester.tap(find.text('Complete Booking'));
    await tester.pump();

    verify(() => mockViewModel.add(SubmitBooking('Paragliding'))).called(1);
  });

  testWidgets('Shows loading indicator when isLoading is true', (tester) async {
    final state = BookingState(isLoading: true);

    await tester.pumpWidget(createWidgetWithState(state));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Complete Booking'), findsNothing);
  });
}
