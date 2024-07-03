class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.balance,
    required this.lastFarmStartTime,
  });
  String id, firstName, lastName, email;
  int balance;
  DateTime? lastFarmStartTime;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        balance: json['balance'],
        lastFarmStartTime: DateTime.parse(json['lastFarmStartTime']));
  }
}
