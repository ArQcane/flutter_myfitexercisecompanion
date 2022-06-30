class UserDetail {
  String email;
  String profilePic;
  String username;
  double weight;
  double height;

  UserDetail({
    required this.email,
    required this.profilePic,
    required this.username,
    required this.weight,
    required this.height
  });

  UserDetail.fromMap(Map<String, dynamic> snapshot) :
        email =  snapshot['userEmail'] ?? '',
        profilePic = snapshot['profilePic'] ?? '',
        username = snapshot['username'] ?? '',
        weight = snapshot['weight'] ?? '',
        height = snapshot['height'] ?? '';
}