import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/app/service_locator/service_locator.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_event.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_state.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_view_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/presentation/view/widgets/booking_bottom_sheet_content.dart';

class AdventureDetailScreen extends StatelessWidget {
  final ActivityApiModel activity;

  const AdventureDetailScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black87,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: BlocBuilder<FavoritesViewModel, FavoritesState>(
                  builder: (context, state) {
                    final isFavorited =
                        state is FavoritesLoaded &&
                        state.favorites.any((fav) => fav.id == activity.id);

                    return IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        if (isFavorited) {
                          context.read<FavoritesViewModel>().add(
                            RemoveFromFavoritesEvent(activity.id!),
                          );
                        } else {
                          context.read<FavoritesViewModel>().add(
                            AddToFavoritesEvent(activity),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    activity.images!.isNotEmpty
                        ? activity.images!.first
                        : 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Image.asset(
                          'assets/images/placeholder.jpg',
                          fit: BoxFit.cover,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            activity.name,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                activity.rating.toString(),
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            Icons.access_time,
                            'Duration',
                            activity.duration,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            Icons.group,
                            'Group Size',
                            'Up to 8', // This is hardcoded in the original, so keeping it
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            context,
                            Icons.fitness_center,
                            'Difficulty',
                            activity.difficulty,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'About This Adventure',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Embark on an unforgettable journey that combines breathtaking scenery with heart-pumping excitement. This carefully curated adventure offers the perfect balance of thrill and safety, guided by our experienced professionals who ensure every moment is both exhilarating and secure.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Highlights',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...[
                      'Professional guide and safety equipment included',
                      'Stunning panoramic views and photo opportunities',
                      'Small group experience for personalized attention',
                      'All skill levels welcome with proper training',
                    ].map(
                      (highlight) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                highlight,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey[50]!, Colors.grey[100]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Starting from',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${activity.price.toStringAsFixed(0)}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2E7D32),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'per person',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '20% OFF',
                                  style: TextStyle(
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
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
                              onPressed: () {
                                _showBookingBottomSheet(
                                  context,
                                  activity.name,
                                  activity.id!,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.calendar_today, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Book This Adventure',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showBookingBottomSheet(
    BuildContext context,
    String adventureTitle,
    String activityId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: serviceLocator<BookingViewModel>(),
          child: BookingBottomSheetContent(
            adventureTitle: adventureTitle,
            activityIdForBooking: activityId,
          ),
        );
      },
    );
  }
}
