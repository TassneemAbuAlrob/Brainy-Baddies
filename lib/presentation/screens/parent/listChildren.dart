import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:log/core/constants/app_contants.dart';
import 'package:log/presentation/screens/parent/showInterest.dart';

class Child {
  final String name;
  final String image;
  final String email;

  Child({required this.name, required this.image, required this.email});

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      name: json['name'],
      image: json['image'],
      email: json['email'],
    );
  }
}

class ChildrenListWidget extends StatefulWidget {
  final String parentId;

  ChildrenListWidget({required this.parentId});

  @override
  _ChildrenListWidgetState createState() => _ChildrenListWidgetState();
}

class _ChildrenListWidgetState extends State<ChildrenListWidget> {
  late Future<List<Child>> _children;

  @override
  void initState() {
    super.initState();
    _children = _fetchChildren();
  }

  Future<List<Child>> _fetchChildren() async {
    final response =
        await http.get(Uri.parse('$baseUrl/children/${widget.parentId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Child> children = data.map((json) => Child.fromJson(json)).toList();
      return children;
    } else {
      throw Exception('Failed to load children');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Children List'),
        backgroundColor: Colors.grey, // Set the background color here
      ),
      body: FutureBuilder<List<Child>>(
        future: _children,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No children available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ChildWidget(child: snapshot.data![index]),
                    SizedBox(height: 16),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  final Child child;

  ChildWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowInterest(email: child.email),
            ),
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(child.image),
        ),
      ),
      title: Text(child.name),
      subtitle: Text(child.email), // Added email as a subtitle
    );
  }
}
