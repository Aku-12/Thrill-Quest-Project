// lib/features/home/presentation/view/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/app/constant/api/api_endpoints.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/presentation/view/widgets/adventure_card.dart';
import 'package:thrill_quest/features/home/presentation/view_model/home_event.dart';
import 'package:thrill_quest/features/home/presentation/view_model/home_state.dart';
import 'package:thrill_quest/features/home/presentation/view_model/home_view_model.dart';

// --- App Constants (remain unchanged) ---
class AppColors {
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryGreen = Color(0xFF43A047);
  static const Color primaryRed = Color(0xFFE53935);
  static const Color primaryOrange = Color(0xFFFF7043);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundExtraLight = Color(0xFFE3F2FD);
}

class AppPadding {
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: 24.0,
  );
  static const EdgeInsets cardContent = EdgeInsets.all(12.0);
}

class AppDurations {
  static const Duration splashDuration = Duration(milliseconds: 500);
}

class ImagePlaceholders {
  static const String noImage =
      'https://placehold.co/600x400/E0E0E0/616161?text=No+Image';
}

// --- HomeScreen as StatelessWidget ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.read<HomeViewModel>();
    if (homeViewModel.state is HomeInitial) {
      homeViewModel.add(const LoadActivities());
    }

    return Scaffold(
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeError) {
            return _buildErrorState(context, state.message);
          } else if (state is HomeLoaded) {
            if (state.activities.isEmpty) {
              return _buildEmptyState(context);
            }

            // CORRECTED: Map ActivityEntity to ActivityApiModel with full image URL.
            final List<ActivityApiModel> adventures = state.activities
                .map((activityEntity) {
                  // Get the first image path or a default placeholder
                  final String imagePath = (activityEntity.images != null &&
                          activityEntity.images!.isNotEmpty)
                      ? '${ApiEndpoints.serverAddress}${activityEntity.images!.first}'
                      : ImagePlaceholders.noImage;

                  // Create a new ActivityApiModel with the full URL
                  return ActivityApiModel(
                    id: activityEntity.id,
                    name: activityEntity.name,
                    location: activityEntity.location,
                    images: [imagePath], // This is the corrected line
                    price: activityEntity.price,
                    duration: activityEntity.duration,
                    difficulty: activityEntity.difficulty,
                    bookings: activityEntity.bookings,
                    rating: activityEntity.rating,
                    status: activityEntity.status,
                  );
                })
                .toList();
                
            final List<Map<String, dynamic>> categories = [
              {
                'name': 'Rafting',
                'icon': Icons.kayaking,
                'color': AppColors.primaryBlue,
              },
              {
                'name': 'Paragliding',
                'icon': Icons.paragliding,
                'color': AppColors.primaryGreen,
              },
              {
                'name': 'Bungee',
                'icon': Icons.sports_kabaddi,
                'color': AppColors.primaryRed,
              },
              {
                'name': 'Balloon',
                'icon': Icons.air,
                'color': AppColors.primaryOrange,
              },
            ];

            return _buildHomePageContent(context, categories, adventures);
          }
          return const Center(child: Text('An unexpected state occurred.'));
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundLight, AppColors.backgroundExtraLight],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.explore_off, size: 60, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              "No Adventures Yet",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Check back later for exciting activities",
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeViewModel>().add(const LoadActivities());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Failed to Load Adventures',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'An unknown error occurred.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeViewModel>().add(const LoadActivities());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePageContent(
      BuildContext context,
      List<Map<String, dynamic>> categories,
      List<ActivityApiModel> adventures,
      ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundLight, Colors.white],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue.withOpacity(0.05),
                    AppColors.primaryGreen.withOpacity(0.03),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 32),
                      _buildGreetingSection(),
                      const SizedBox(height: 28),
                      _buildSearchBar(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppPadding.screenHorizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Categories", "Explore activities"),
                  const SizedBox(height: 20),
                  _buildCategoriesGrid(categories),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
              child: _buildSectionHeader(
                "Popular Adventures",
                "${adventures.length} activities available",
              ),
            ),
          ),
          SliverPadding(
            padding: AppPadding.screenHorizontal,
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final adventure = adventures[index];
                return buildAdventureCard(context, adventure);
              }, childCount: adventures.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: AppColors.primaryBlue, size: 16),
              const SizedBox(width: 6),
              Text(
                "Kathmandu, Nepal",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[400]!, Colors.orange[600]!],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wb_sunny, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                "28°C",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ready for an",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: Colors.grey[700],
            height: 1.2,
          ),
        ),
        Text(
          "Adventure?",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Discover thrilling experiences in Nepal",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search adventures...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryGreen],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(List<Map<String, dynamic>> categories) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(category: category);
        },
      ),
    );
  }

  Widget _buildModernAdventureCard(
      BuildContext context,
      ActivityApiModel adventure,
      ) {
    return buildAdventureCard(
      context,
      adventure,
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (category['color'] as Color).withOpacity(0.1),
                  (category['color'] as Color).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (category['color'] as Color).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              category['icon'] as IconData,
              color: category['color'] as Color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['name'] as String,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}