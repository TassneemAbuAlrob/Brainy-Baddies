import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/providers/home_provider.dart';
import 'package:alaa_admin/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:alaa_admin/models/user.dart';
import 'package:alaa_admin/services/users_service.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  late Future<List<User>> _users;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _users = UserService.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              height: 80,
              width: media.width * 0.9,
              child: TextField(
                controller: _searchController,
                onChanged: (_) {
                  setState(() {}); // Trigger a rebuild on text change
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Users',
                  isDense: true,
                  isCollapsed: true,
                  filled: true,
                  fillColor: Colors.white,
                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<User>>(
              future: _users,
              builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data != null) {
                  final searchQuery = _searchController.text.toLowerCase();
                  final filteredUsers = snapshot.data!
                      .where((user) =>
                  user.name.toLowerCase().contains(searchQuery) ||
                      user.email.toLowerCase().contains(searchQuery))
                      .toList();

                  if (filteredUsers.isEmpty) {
                    return Center(
                      child: Text(
                        'No Users Found',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12.0)
                        ),
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  user: user
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            backgroundImage: CachedNetworkImageProvider(
                              user.image,
                            ),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDeleteConfirmationDialog(context, user);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }

                return Center(
                  child: Text('No Data Available'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Do you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                await UserService.deleteUser(user.id);
                _users = UserService.getAllUsers();
                await context.read<HomeProvider>().initializeCounts();
                setState(() {
                  
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
