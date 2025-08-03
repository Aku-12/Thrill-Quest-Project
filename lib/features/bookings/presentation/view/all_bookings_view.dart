import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:thrill_quest/features/bookings/domain/entity/bookings_entity.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/all_bookings_event.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/all_bookings_state.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/all_bookings_view_model.dart';

class AllBookingsView extends StatelessWidget {
  const AllBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AllBookingsViewModel>().add(FetchAllBookings());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<AllBookingsViewModel, BookingsState>(
        builder: (context, state) {
          if (state is BookingsLoading || state is BookingsInitial) {
            return _buildLoadingState();
          }
          if (state is BookingsError) {
            return _ErrorDisplay(message: state.message);
          }
          if (state is BookingsLoaded) {
            if (state.bookings.isEmpty) {
              return _buildEmptyState();
            }
            return _buildBookingsList(context, state.bookings);
          }
          return const Center(child: Text('An unexpected error occurred.'));
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Loading your bookings...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.1),
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 60,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'No Bookings Yet',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your adventure bookings will appear here\nonce you make a reservation.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(
    BuildContext context,
    List<BookingsEntity> bookings,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AllBookingsViewModel>().add(FetchAllBookings());
      },
      color: const Color(0xFF6366F1),
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _ModernBookingCard(
                  booking: bookings[index],
                  isLast: index == bookings.length - 1,
                  index: index,
                );
              }, childCount: bookings.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernBookingCard extends StatefulWidget {
  final BookingsEntity booking;
  final bool isLast;
  final int index;

  const _ModernBookingCard({
    required this.booking,
    this.isLast = false,
    required this.index,
  });

  @override
  State<_ModernBookingCard> createState() => _ModernBookingCardState();
}

class _ModernBookingCardState extends State<_ModernBookingCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation; // Keep late as it's initialized in initState
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Initialize _slideAnimation after _animationController
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<double>(begin: -20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Staggered entry animation
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'paid':
        return const Color(0xFF059669); // Emerald
      case 'completed':
        return const Color(0xFF2563EB); // Blue
      case 'pending':
        return const Color(0xFFD97706); // Amber
      case 'cancelled':
      case 'canceled':
      case 'refunded':
        return const Color(0xFFDC2626); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'paid':
        return Icons.check_circle_rounded;
      case 'completed':
        return Icons.task_alt_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      case 'cancelled':
      case 'canceled':
      case 'refunded':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tourDateFormatted = DateFormat(
      'MMM dd, yyyy',
    ).format(widget.booking.tourDate);
    final tourTimeFormatted = DateFormat(
      'h:mm a',
    ).format(widget.booking.tourDate);

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 20),
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.95),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 20,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            children: [
                              // Header Section with Gradient Background
                              GestureDetector(
                                onTapDown: (_) => _scaleController.forward(),
                                onTapUp: (_) => _scaleController.reverse(),
                                onTapCancel: () => _scaleController.reverse(),
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(
                                          0xFF6366F1,
                                        ).withOpacity(0.02),
                                        const Color(
                                          0xFF8B5CF6,
                                        ).withOpacity(0.02),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.booking.activityName ??
                                                      'Unknown Activity',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF1E293B),
                                                    letterSpacing: -0.3,
                                                    height: 1.2,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                        6,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFF6366F1,
                                                        ).withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8),
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .calendar_today_rounded,
                                                        size: 16,
                                                        color: Color(
                                                          0xFF6366F1,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          tourDateFormatted,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                              0xFF374151,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          tourTimeFormatted,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.grey[600],
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          AnimatedRotation(
                                            turns: _isExpanded ? 0.5 : 0.0,
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF6366F1,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.expand_more_rounded,
                                                color: Color(0xFF6366F1),
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          _EnhancedStatusChip(
                                            label: widget.booking.bookingStatus,
                                            color: _getStatusColor(
                                              widget.booking.bookingStatus,
                                            ),
                                            icon: _getStatusIcon(
                                              widget.booking.bookingStatus,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          _EnhancedStatusChip(
                                            label: widget.booking.paymentStatus,
                                            color: _getStatusColor(
                                              widget.booking.paymentStatus,
                                            ),
                                            icon: Icons.payment_rounded,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Expanded Content with Enhanced Design
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOutCubic,
                                height: _isExpanded ? null : 0,
                                child: _isExpanded
                                    ? Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          24,
                                          0,
                                          24,
                                          24,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFFF8FAFC),
                                              Colors.white.withOpacity(0.8),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey[200]!,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 24),
                                            _EnhancedDetailItem(
                                              icon: Icons
                                                  .person_outline_rounded,
                                              label: 'Customer',
                                              value:
                                                  widget.booking.customerName,
                                              color: const Color(0xFF059669),
                                            ),
                                            _EnhancedDetailItem(
                                              icon:
                                                  Icons.support_agent_rounded,
                                              label: 'Guide',
                                              value: widget.booking.guideName,
                                              color: const Color(0xFF2563EB),
                                            ),
                                            if (widget.booking.location !=
                                                null)
                                              _EnhancedDetailItem(
                                                icon: Icons
                                                    .location_on_outlined,
                                                label: 'Location',
                                                value:
                                                    widget.booking.location!,
                                                color: const Color(
                                                  0xFFDC2626,
                                                ),
                                              ),
                                            if (widget.booking.duration !=
                                                null)
                                              _EnhancedDetailItem(
                                                icon: Icons.schedule_rounded,
                                                label: 'Duration',
                                                value:
                                                    widget.booking.duration!,
                                                color: const Color(
                                                  0xFFD97706,
                                                ),
                                              ),
                                            if (widget.booking.price != null)
                                              _EnhancedDetailItem(
                                                icon: Icons
                                                    .attach_money_rounded,
                                                label: 'Price',
                                                value:
                                                    '\$${widget.booking.price!.toStringAsFixed(2)}',
                                                color: const Color(
                                                  0xFF059669,
                                                ),
                                                isPrice: true,
                                              ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EnhancedStatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _EnhancedStatusChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnhancedDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isPrice;

  const _EnhancedDetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isPrice ? color : const Color(0xFF1E293B),
                    letterSpacing: isPrice ? 0.3 : 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorDisplay extends StatelessWidget {
  final String message;
  const _ErrorDisplay({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFEF4444).withOpacity(0.1),
                    const Color(0xFFDC2626).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEF4444).withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFEF4444),
                size: 50,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Something Went Wrong',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<AllBookingsViewModel>().add(FetchAllBookings());
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}