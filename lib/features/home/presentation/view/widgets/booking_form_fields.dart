// lib/features/home/presentation/view/widgets/booking_form_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_event.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_state.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';

class BookingFormFields extends StatelessWidget {
  final String adventureTitle; // Receive the pre-selected activity title (used as fallback)

  const BookingFormFields({super.key, required this.adventureTitle});

  Future<void> _selectDate(BuildContext context, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF2E7D32), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.grey[900]!, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2E7D32), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && context.mounted) {
      context.read<BookingViewModel>().add(DateSelected(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingViewModel, BookingState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Field (Non-editable, showing the activityName from state)
            _buildReadOnlyField(
              context,
              label: 'Selected Activity',
              // Use state.selectedActivityName, fallback to adventureTitle if not set yet
              value: state.selectedActivityName ?? adventureTitle,
            ),
            const SizedBox(height: 16),

            // Guide Selection Dropdown
            Text(
              'Select Guide',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 8),
            state.isGuidesLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  ) // Show loading for guides
                : DropdownButtonFormField<String>(
                    value: state.selectedGuide != null &&
                            state.availableGuides.any((guide) => guide.name == state.selectedGuide)
                        ? state.selectedGuide
                        : null, // Ensure value matches an item, else set to null
                    decoration: InputDecoration(
                      hintText: 'Choose a guide',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF2E7D32),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: state.availableGuides.map((GuideEntity guide) {
                      return DropdownMenuItem<String>(
                        value: guide.name, // Use guide.name for the value
                        child: Text(guide.name),
                      );
                    }).toList(),
                    onChanged: state.availableGuides.isEmpty // Disable if no guides are available
                        ? null
                        : (String? newValue) {
                            context.read<BookingViewModel>().add(GuideSelected(newValue));
                          },
                  ),
            const SizedBox(height: 16),

            // Date Selection
            Text(
              'Select Date',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(
                context,
                state.selectedDate,
              ), // Pass current selected date
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.selectedDate == null
                          ? 'Choose a date'
                          : DateFormat(
                              'dd/MM/yyyy',
                            ).format(state.selectedDate!), // Format the date
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: state.selectedDate == null
                                ? Colors.grey[600]
                                : Colors.grey[900],
                          ),
                    ),
                    Icon(Icons.calendar_today, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method for read-only text fields
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
                fontWeight: FontWeight.bold,
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
              borderSide: BorderSide.none, // No border for filled background
            ),
            filled: true,
            fillColor: Colors.grey[100], // A subtle background for read-only
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }
}