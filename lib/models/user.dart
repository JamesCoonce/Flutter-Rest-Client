import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  User({this.id, this.name, this.username, this.email, this.address, this.phone, this.website, this.company});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      phone: json['phone'],
      website: json['website'],
      company: Company.fromJson(json['company'])
    );
  }
}

class Address {
  final String street;
  final String suit;
  final String city;
  final String zipcode;

  Address({this.street, this.suit, this.city, this.zipcode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return new Address(
      street: json['street'],
      suit: json['suit'],
      city: json['city'],
      zipcode: json['zipcode']
    );
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({this.name, this.catchPhrase, this.bs});

  factory Company.fromJson(Map<String, dynamic> json){
    return new Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs']
    );
  }
}

Future<User> fetchUser(int userId) async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/users/$userId');
  final responseJson = json.decode(response.body);

  return new User.fromJson(responseJson);
}

Future<List<User>> fetchUsers() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/users');
  var responseJson = json.decode(response.body);

  var userList = new List<User>();
  for(var item in responseJson){
    var user;
    user = new User.fromJson(item);


    userList.add(user);
  }

  for(var user in userList){
    print(user.name + " works for " + user.company.name);
  }

  return userList;
}
