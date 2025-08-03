class ActivityEntity {
  final String id;
  final String name;
  final String location;
  final List<String>? images;
  final double price;
  final String duration;
  final String difficulty; // "Beginner", "Intermediate", "Advanced"
  final int bookings;
  final double rating;
  final String status; // "Active", "On Hold"

  const ActivityEntity({
    required this.id,
    required this.name,
    required this.location,
    this.images,
    required this.price,
    required this.duration,
    required this.difficulty,
    required this.bookings,
    required this.rating,
    required this.status,
  });

  @override
  String toString() {
    return 'ActivityEntity(id: $id, name: $name, location: $location, images: $images, price: $price, '
        'duration: $duration, difficulty: $difficulty, bookings: $bookings, rating: $rating, status: $status)';
  }
}
