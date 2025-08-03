import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thrill_quest/app/service_locator/service_locator.dart';
import 'package:thrill_quest/features/favorites/presentation/view_model/favorites_view_model.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/presentation/view/widgets/adventure_detail_screen.dart';

Color _getDifficultyColor(String difficulty) {
  switch (difficulty.toLowerCase()) {
    case 'easy':
      return Colors.green;
    case 'moderate':
      return Colors.orange;
    case 'extreme':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

Widget buildAdventureCard(BuildContext context, ActivityApiModel adventure) {
  final imageUrl =
      (adventure.images != null && adventure.images!.isNotEmpty)
          ? adventure.images!.first
          : 'assets/images/placeholder.jpg';

  return GestureDetector(
    onTap: () {
      HapticFeedback.lightImpact();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<FavoritesViewModel>(),
                child: AdventureDetailScreen(activity: adventure),
              ),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image:
                      imageUrl.startsWith('http')
                          ? NetworkImage(imageUrl) as ImageProvider
                          : AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            adventure.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adventure.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        adventure.duration,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(
                            adventure.difficulty.toString(),
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          adventure.difficulty.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getDifficultyColor(
                              adventure.difficulty.toString(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '\$${adventure.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
