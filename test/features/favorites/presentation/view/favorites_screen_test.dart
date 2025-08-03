import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:thrill_quest/features/favorites/presentation/view/favorites_screen.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_state.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_view_model.dart';

// Mock FavoritesViewModel Bloc
class MockFavoritesViewModel extends Mock implements FavoritesViewModel {}

void main() {
  late MockFavoritesViewModel mockFavoritesViewModel;

  setUp(() {
    mockFavoritesViewModel = MockFavoritesViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<FavoritesViewModel>.value(
        value: mockFavoritesViewModel,
        child: const FavoritesScreen(),
      ),
    );
  }

  testWidgets('shows loading indicator when state is FavoritesLoading', (tester) async {
    when(() => mockFavoritesViewModel.state).thenReturn(FavoritesLoading());
    whenListen(mockFavoritesViewModel, Stream.value(FavoritesLoading()));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when state is FavoritesError', (tester) async {
    const errorMessage = 'Failed to load favorites';
    when(() => mockFavoritesViewModel.state).thenReturn(FavoritesError(message: errorMessage));
    whenListen(mockFavoritesViewModel, Stream.value(FavoritesError(message: errorMessage)));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text(errorMessage), findsOneWidget);
    final textWidget = tester.widget<Text>(find.text(errorMessage));
    expect(textWidget.style?.color, Colors.red);
  });

  testWidgets('shows empty message when favorites list is empty', (tester) async {
    when(() => mockFavoritesViewModel.state).thenReturn(FavoritesLoaded(favorites: []));
    whenListen(mockFavoritesViewModel, Stream.value(FavoritesLoaded(favorites: [])));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('You have no favorite activities.'), findsOneWidget);
  });

//   testWidgets('shows list of favorite activities when state is FavoritesLoaded with items', (tester) async {
//     final favorites = [
//       ActivityEntity(
//         id: '1',
//         name: 'Activity 1',
//         location: 'Location 1',
//         images: ['https://example.com/image1.jpg'],
//         price: 10.5,
//         duration: '2 hours',
//         difficulty: 'Beginner',
//         bookings: 15,
//         rating: 4.5,
//         status: 'Active',
//       ),
//       ActivityEntity(
//         id: '2',
//         name: 'Activity 2',
//         location: 'Location 2',
//         images: [],
//         price: 20.0,
//         duration: '3 hours',
//         difficulty: 'Intermediate',
//         bookings: 10,
//         rating: 4.0,
//         status: 'Active',
//       ),
//     ];

//     when(() => mockFavoritesViewModel.state).thenReturn(FavoritesLoaded(favorites: favorites));
//     whenListen(mockFavoritesViewModel, Stream.value(FavoritesLoaded(favorites: favorites)));

//     await tester.pumpWidget(createWidgetUnderTest());
//     await tester.pumpAndSettle();

//     // Should find two ListTiles
//     expect(find.byType(ListTile), findsNWidgets(2));

//     // Check texts for first activity
//     expect(find.text('Activity 1'), findsOneWidget);
//     expect(find.text('Location 1'), findsOneWidget);
//     expect(find.text('\$10.50'), findsOneWidget);

//     // Check texts for second activity
//     expect(find.text('Activity 2'), findsOneWidget);
//     expect(find.text('Location 2'), findsOneWidget);
//     expect(find.text('\$20.00'), findsOneWidget);

//     // First item has Image.network, second has Icon (no images)
//     expect(find.byType(Image), findsOneWidget);
//     expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
//   });
}
