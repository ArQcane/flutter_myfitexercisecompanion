import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myfitexercisecompanion/data/models/user_model.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/auth_repository.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/run_repository.dart';
import 'package:flutter_myfitexercisecompanion/data/repositories/user_repository.dart';
import 'package:flutter_myfitexercisecompanion/screens/chat/chats_individual_screen.dart';
import 'package:flutter_myfitexercisecompanion/widgets/loading_circle.dart';
import 'package:shimmer/shimmer.dart';

class SearchUserScreen extends StatefulWidget {
  UserDetail user;

  SearchUserScreen(this.user);

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;
  String? profilePic;

  Color get _baseColor {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[600]!
        : Colors.grey[300]!;
  }

  Color get _highlightColor {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[100]!
        : Colors.grey[50]!;
  }

  void onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found under this username")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['username'] != widget.user.username) {
          searchResult.add(user.data());
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Search your friends!'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        hintText: "Type Username...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    onSearch();
                  },
                  icon: Icon(Icons.search)),
            ],
          ),
          if (searchResult.length > 0)
            Expanded(
                child: ListView.builder(
                    itemCount: searchResult.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return FutureBuilder<String?>(
                          future: FirebaseStorage.instance
                              .ref()
                              .child(searchResult[index]['profilePic'] ?? "")
                              .getDownloadURL(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingCircle();
                            }
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                child: snapshot.hasData ? Image.network(
                                  snapshot.data!,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Shimmer.fromColors(
                                        child: Container(
                                          color: _baseColor,
                                        ),
                                        baseColor: _baseColor,
                                        highlightColor: _highlightColor);
                                  },
                                ) : CircleAvatar(child: Icon(Icons.person)),
                              ),
                              title: Text(searchResult[index]["username"]),
                              subtitle:
                                  Text(searchResult[index]["email"] ?? ""),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchController.text = "";
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatsIndividualScreen(
                                          currentUser: widget.user,
                                          friendEmail: searchResult[index]
                                              ['email'],
                                          friendName: searchResult[index]
                                              ['username'],
                                          friendImage: searchResult[index]
                                              ['profilePic']),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.message),
                              ),
                            );
                          });
                    }))
          else if (isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
