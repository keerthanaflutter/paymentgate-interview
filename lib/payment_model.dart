class User {
  final String name;
  final String picture;
  int paymentAmount;
  bool isCash;
  bool isPaid;

  User({
    required this.name,
    required this.picture,
    required this.paymentAmount,
    required this.isCash,
    this.isPaid = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: '${json['name']['first']} ${json['name']['last']}',
      picture: json['picture']['large'],
      paymentAmount: 2500,
      isCash: true,
    );
  }
}