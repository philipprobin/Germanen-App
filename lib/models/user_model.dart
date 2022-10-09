class UserModel {
  var userId;
  var hobbys;
  var job;
  var activeSince;
  var mayor;
  var location;
  var status;
  var image;

  UserModel getUser() {
    return this;
  }

  UserModel({
    required this.userId,
    required this.hobbys,
    required this.status,
    required this.activeSince,
    required this.mayor,
    required this.job,
    required this.location,
    required this.image
  });

}
