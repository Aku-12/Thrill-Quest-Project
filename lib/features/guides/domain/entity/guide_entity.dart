class GuideEntity {
  final String id;
  final String name;
  final String email;
  final List<String> specialties;
  final int experience;
  final int assignedTours;
  final List<double> ratings;
  final double averageRating;
  final String status;

  const GuideEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.specialties,
    required this.experience,
    required this.assignedTours,
    required this.ratings,
    required this.averageRating,
    required this.status,
  });

  @override
  String toString() {
    return 'GuideEntity(id: $id, name: $name, email: $email, specialties: $specialties, '
        'experience: $experience, assignedTours: $assignedTours, ratings: $ratings, '
        'averageRating: $averageRating, status: $status)';
  }
}
