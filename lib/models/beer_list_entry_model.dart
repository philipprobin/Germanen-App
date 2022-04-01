class BeerListEntryModel {
  final String userId;
  final int beers;


  String getUserId() {
    return userId;
  }
  BeerListEntryModel(
      {required this.userId, required this.beers});
}
