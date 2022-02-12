class Rating {
  String reviewerUID;
  String revieweeUID;
  double rating;
  String text;

  Rating(
      {required this.reviewerUID,
      required this.revieweeUID,
      required this.rating,
      required this.text});
}
