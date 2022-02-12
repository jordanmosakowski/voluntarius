class User {
  String UUID;
  List<String> notificationTokens;
  double averageStars;
  int numReviews;

  User(
      {required this.UUID,
      required this.notificationTokens,
      required this.averageStars,
      required this.numReviews});
}
