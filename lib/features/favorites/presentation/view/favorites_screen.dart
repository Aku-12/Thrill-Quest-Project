import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_state.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_view_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FavoritesViewModel, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is FavoritesLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(
                child: Text('You have no favorite activities.'),
              );
            }
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final activity = state.favorites[index];
                return ListTile(
                  leading:
                      activity.images != null && activity.images!.isNotEmpty
                          ? Image.network(
                            activity.images!.first,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                          : const Icon(Icons.image_not_supported),
                  title: Text(activity.name),
                  subtitle: Text(activity.location),
                  trailing: Text('\$${activity.price.toStringAsFixed(2)}'),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
