class ReviewEntity {
  final String id;
  final String activityId;
  final String userId;
  final String userName;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewEntity({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.userName,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'ReviewEntity(id: $id, activityId: $activityId, userId: $userId, '
           'userName: $userName, rating: $rating, comment: $comment, '
           'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
