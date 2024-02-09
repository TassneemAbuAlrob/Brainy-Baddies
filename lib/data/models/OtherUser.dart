class OtherUser {
  final String id;
  final String email;
  final String name;
  final String role;
  final String image;
  final String joinedAt;
  final String phone;
  final String uniqueId;
  final List<String> followers;
  final List<String> followings;
  bool isFollowing;
  String? parentUser;
  String? password;

  OtherUser(
      {required this.email,
      required this.name,
      required this.role,
      required this.image,
      required this.joinedAt,
      required this.phone,
      this.isFollowing = true,
      required this.id,
      required this.uniqueId,
      required this.followings,
      required this.followers,
      this.parentUser,
      this.password});

  factory OtherUser.fromJson(Map data) {
    return OtherUser(
      email: data['email'],
      name: data['name'],
      role: data['role'],
      image: data['image'],
      joinedAt: data['joined_at'] ?? '',
      followers: [],
      followings: [],
      phone: data['phone'],
      uniqueId: data['unique_id'] ?? '',
      id: data['_id'] ?? '',
      parentUser: data['parentUser'] ?? '',
    );
  }

  Map<String, String> toJson() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'image': image,
      'phone': phone,
      'password': password ?? '',
      'unique_id': uniqueId,
      'parentUser': parentUser ?? '',
    };
  }
}
