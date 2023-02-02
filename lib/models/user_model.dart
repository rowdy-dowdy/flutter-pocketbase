class UserModel {
  final String id;
  final String username;
  final String email;
  final DateTime created;
  final DateTime updated;

  UserModel(this.id, this.username, this.email, this.created, this.updated);

  UserModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      username = json['username'],
      email = json['email'],
      created = json['created'],
      updated = json['updated'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'created': created,
    'updated': updated,
  };
}