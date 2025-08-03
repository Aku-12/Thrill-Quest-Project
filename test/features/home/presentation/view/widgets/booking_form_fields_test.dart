import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:thrill_quest/features/home/presentation/view/widgets/booking_form_fields.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_state.dart';

class MockBookingViewModel extends Mock implements BookingViewModel {}

void main() {
  late BookingViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockBookingViewModel();
  });

  Widget createTestWidget(BookingState state) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<BookingViewModel>.value(
          value: mockViewModel,
          child: BookingFormFields(adventureTitle: 'Paragliding'),
        ),
      ),
    );
  }

  testWidgets('Displays selected activity title', (tester) async {
    final state = BookingState(
      selectedActivityName: 'Skydiving',
    );

    when(() => mockViewModel.state).thenReturn(state);
    when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createTestWidget(state));

    expect(find.text('Skydiving'), findsOneWidget);
  });


  testWidgets('Tapping date picker shows date dialog', (tester) async {
    final state = BookingState(
      selectedDate: null,
    );

    when(() => mockViewModel.state).thenReturn(state);
    when(() => mockViewModel.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(createTestWidget(state));
    await tester.pumpAndSettle();

    expect(find.text('Choose a date'), findsOneWidget);

    await tester.tap(find.text('Choose a date'));
    await tester.pumpAndSettle();

    // Since we can't interact with native date picker, just ensure it opened
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
