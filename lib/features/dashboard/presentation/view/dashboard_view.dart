import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/app/service_locator/service_locator.dart';
import 'package:thrill_quest/features/bookings/presentation/view/all_bookings_view.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/all_bookings_view_model.dart';
import 'package:thrill_quest/features/bookings/presentation/view_model/booking_view_model.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:thrill_quest/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:thrill_quest/features/favorites/presentation/view/favorites_screen.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_event.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_view_model.dart';
import 'package:thrill_quest/features/home/presentation/view/home_screen.dart';
import 'package:thrill_quest/features/home/presentation/view_model/home_view_model.dart';
import 'package:thrill_quest/features/profile/presentation/view/profile_screen.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_event.dart';
import 'package:thrill_quest/features/profile/presentation/view_model/profile_view_model.dart';
// Import the sensors_plus package
import 'package:sensors_plus/sensors_plus.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  // Threshold to detect a shake
  static const double shakeThreshold = 10.0;
  // A subscription to the accelerometer data stream
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    // Subscribe to accelerometer events from sensors_plus
    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      // Calculate the magnitude of the acceleration vector
      final double magnitude =
          (event.x * event.x + event.y * event.y + event.z * event.z);
      // Check if the magnitude exceeds the shake threshold
      if (magnitude > shakeThreshold * shakeThreshold) {
        // If a shake is detected, show the logout confirmation dialog
        _showLogoutConfirmationDialog();
      }
    });
  }

  @override
  void dispose() {
    // Cancel the subscription to prevent memory leaks
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  // A list of all the screens accessible from the bottom navigation bar.
  Widget _buildScreen(int currentIndex) {
    // IndexedStack preserves the state of the screens when switching tabs.
    return IndexedStack(
      index: currentIndex,
      children: [
        // Screen 1: Home
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: serviceLocator<BookingViewModel>()),
            BlocProvider.value(value: serviceLocator<HomeViewModel>()),
          ],
          child: HomeScreen(),
        ),
        // Screen 2: Favorites
        BlocProvider(
          create: (context) =>
              serviceLocator<FavoritesViewModel>()..add(FetchFavoritesEvent()),
          child: FavoritesScreen(),
        ),
        // Screen 3: Bookings
        BlocProvider(
          create: (context) => serviceLocator<AllBookingsViewModel>(),
          child: AllBookingsView(),
        ),
        // Screen 4: Profile
        BlocProvider(
          create: (context) =>
              serviceLocator<ProfileViewModel>()..add(FetchUserProfileEvent()),
          child: ProfileScreen(),
        ),
      ],
    );
  }

  // Shows a dialog asking for confirmation before logging out.
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
                context.read<DashboardViewModel>().add(
                      LogoutEvent(context: context),
                    );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardViewModel, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: _buildAppBar(context, state.currentIndex),
          body: _buildScreen(state.currentIndex),
          bottomNavigationBar: NavigationView(
            currentIndex: state.currentIndex,
            onTabChanged: (index) {
              context.read<DashboardViewModel>().add(
                    DashboardTabChanged(tabIndex: index),
                  );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, int currentIndex) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2E7D32).withOpacity(0.1),
              const Color(0xFF4CAF50).withOpacity(0.05),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.explore, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            "Thrill Quest",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
              fontSize: 22,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Handle notification button press
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF2E7D32),
              size: 20,
            ),
          ),
        ),
        if (currentIndex == 3)
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog();
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.logout, color: Colors.red, size: 20),
            ),
          ),
      ],
    );
  }
}

/// A custom bottom navigation bar for the DashboardView.
class NavigationView extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const NavigationView({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabChanged,
      selectedItemColor: const Color(0xFF2E7D32),
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 11,
      ),
      elevation: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          activeIcon: Icon(Icons.book),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}