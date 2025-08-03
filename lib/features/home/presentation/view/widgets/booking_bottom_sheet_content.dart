// lib/features/home/presentation/view/widgets/booking_bottom_sheet_content.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_event.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_state.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';

class BookingBottomSheetContent extends StatefulWidget {
  final String adventureTitle;
  final String activityIdForBooking;

  const BookingBottomSheetContent({
    super.key,
    required this.adventureTitle,
    required this.activityIdForBooking,
  });

  @override
  State<BookingBottomSheetContent> createState() =>
      _BookingBottomSheetContentState();
}

class _BookingBottomSheetContentState
    extends State<BookingBottomSheetContent> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    context.read<BookingViewModel>().add(
          ActivitySelected(
            activityId: widget.activityIdForBooking,
            activityName: widget.adventureTitle,
          ),
        );
    context.read<BookingViewModel>().add(const FetchGuides());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null && context.mounted) {
      context.read<BookingViewModel>().add(DateSelected(picked));
    }
  }

  Future<bool> _authenticateUser() async {
    try {
      bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();
      if (canAuthenticateWithBiometrics || isDeviceSupported) {
        final didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to complete your booking',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        return didAuthenticate;
      }
    } catch (e) {
      debugPrint('Biometric auth error: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingViewModel, BookingState>(
      listener: (context, state) {
        if (state.bookingSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Booking for ${state.selectedActivityName ?? ''} with ${state.selectedGuide ?? ''} on ${state.selectedDate != null ? DateFormat('dd/MM/yyyy').format(state.selectedDate!) : ''} confirmed!',
              ),
              backgroundColor: const Color(0xFF2E7D32),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.read<BookingViewModel>().add(const ResetBookingState());
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.read<BookingViewModel>().add(const ResetBookingState());
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Book Your Adventure',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildReadOnlyField(
                context,
                label: 'Selected Activity',
                value: state.selectedActivityName ?? widget.adventureTitle,
              ),
              const SizedBox(height: 16),
              Text(
                'Select a Guide',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
              ),
              const SizedBox(height: 8),
              state.isGuidesLoading
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      key: ValueKey(state.availableGuides.length),
                      value: state.selectedGuide != null &&
                              state.availableGuides.any(
                                  (guide) => guide.name == state.selectedGuide)
                          ? state.selectedGuide
                          : null,
                      hint: const Text('Choose a guide'),
                      items: state.availableGuides.map((GuideEntity guide) {
                        return DropdownMenuItem<String>(
                          value: guide.name,
                          child: Text(guide.name),
                        );
                      }).toList(),
                      onChanged: state.availableGuides.isEmpty
                          ? null
                          : (String? newValue) {
                              context
                                  .read<BookingViewModel>()
                                  .add(GuideSelected(newValue));
                            },
                    ),
              const SizedBox(height: 16),
              Text(
                'Select Date',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Choose a date',
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF2E7D32),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    controller: TextEditingController(
                      text: state.selectedDate != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(state.selectedDate!)
                          : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: state.isLoading
                      ? null
                      : (state.selectedActivityId == null ||
                              state.selectedGuide == null ||
                              state.selectedDate == null)
                          ? null
                          : () async {
                              HapticFeedback.lightImpact();
                              final isAuthenticated = await _authenticateUser();
                              if (isAuthenticated && context.mounted) {
                                context.read<BookingViewModel>().add(
                                      SubmitBooking(state.selectedActivityId!),
                                    );
                              } else if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Authentication failed. Booking not completed.'),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Complete Booking',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyField(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }
}
