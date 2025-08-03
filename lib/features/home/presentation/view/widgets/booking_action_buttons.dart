// lib/features/home/presentation/widgets/booking_action_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_event.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_state.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';

class BookingActionButtons extends StatelessWidget {
  final String adventureTitle; // Add this to receive the adventure title

  const BookingActionButtons({
    super.key,
    required this.adventureTitle,
  }); // Update constructor

  @override
  Widget build(BuildContext context) {
    final bookingBloc = context.read<BookingViewModel>();
    return BlocBuilder<BookingViewModel, BookingState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context); // Dismiss the bottom sheet
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Pass the adventureTitle when submitting the booking
                  bookingBloc.add(SubmitBooking(adventureTitle));
                },
                child:
                    state.isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          'Complete Booking',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ],
        );
      },
    );
  }
}
