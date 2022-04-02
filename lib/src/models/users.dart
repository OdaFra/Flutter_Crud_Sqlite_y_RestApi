class UsersModel {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String avatar;
  UsersModel(
      {required this.id,
      required this.email,
      required this.firstname,
      required this.lastname,
      required this.avatar});

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
        id: json['id'],
        email: json['email'],
        firstname: json['first_name'] ?? 'First Name',
        lastname: json['last_name'] ?? 'Last Name',
        avatar: json['avatar'] ??
            'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?w=740');
  }
}
