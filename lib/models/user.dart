class User {
  String email;
  String profilePic;
  String username;
  int weight;
  int height;

  User({
    required this.email,
    required this.profilePic,
    required this.username,
    required this.weight,
    required this.height
  });

  User.fromMap(Map<String, dynamic> snapshot, String id)
      :
        email =  snapshot['email'] ?? '',
        profilePic = snapshot['profilePic'] ?? '',
        username = snapshot['username'] ?? '',
        weight = snapshot['weight'] ?? '',
        height = snapshot['height'] ?? '';
}