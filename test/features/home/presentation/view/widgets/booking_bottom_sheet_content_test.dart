import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_state.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';
import 'package:thrill_quest/features/home/presentation/view/widgets/booking_bottom_sheet_content.dart';

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
          child: BookingBottomSheetContent(
            adventureTitle: 'Paragliding',
            activityIdForBooking: 'id-123',
          ),
        ),
      ),
    );
  }

  testWidgets('Displays selected activity', (tester) async {
    final state = BookingState(selectedActivityName: 'Skydiving');

    await tester.pumpWidget(createWidgetWithState(state));

    expect(find.text('Selected Activity'), findsOneWidget);
    expect(find.text('Skydiving'), findsOneWidget);
  });

  testWidgets('Date displays correctly when selected', (tester) async {
    final selectedDate = DateTime(2025, 8, 5);

    final state = BookingState(
      selectedDate: selectedDate,
    );

    await tester.pumpWidget(createWidgetWithState(state));

    expect(find.text('05/08/2025'), findsOneWidget); // Formatted correctly
  });

  testWidgets('Booking button is disabled when data is incomplete', (tester) async {
    final state = BookingState(
      selectedActivityId: null,
      selectedGuide: null,
      selectedDate: null,
    );

    await tester.pumpWidget(createWidgetWithState(state));
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNull);
  });

  testWidgets('Booking button is enabled when all data is filled', (tester) async {
    final state = BookingState(
      selectedActivityId: 'id-123',
      selectedGuide: 'Alice',
      selectedDate: DateTime(2025, 8, 5),
      isLoading: false,
    );

    await tester.pumpWidget(createWidgetWithState(state));
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNotNull);
  });
}
