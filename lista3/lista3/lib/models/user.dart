class User {
  final int? id;
  final String name;
  final int age;
  final String address;

  User({this.id, required this.name, required this.age, required this.address});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String,
        age: (json['age'] as num).toInt(),
        address: json['address'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'address': address,
      };
}
