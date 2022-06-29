class User {
  String email;
  String username;
  final int weight;
  final int height;

  User({
    required this.email,
    required this.username,
    required this.weight,
    required this.height
  });

  User.fromMap(Map<String, dynamic> snapshot, String id)
      :
        email =  snapshot['email'] ?? '',
        username = snapshot['username'] ?? '',
        weight = snapshot['weight'] ?? '',
        height = snapshot['height'] ?? '';
}