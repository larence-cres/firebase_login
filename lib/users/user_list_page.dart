import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance.ref('users');

    return Scaffold(
      body: StreamBuilder(
        stream: databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.snapshot.value;
            if (data != null) {
              Map<dynamic, dynamic> dataMap;
              if (data is List<Object?>) {
                dataMap = Map.fromEntries(data.asMap().entries.map((entry) => MapEntry(entry.key, entry.value as Map<dynamic, dynamic>)));
              } else {
                dataMap = data as Map<dynamic, dynamic>;
              }
              final userList = List<Map<dynamic, dynamic>>.from(dataMap.values.toList());
              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return ListTile(
                    title: Text(user['name']),
                    subtitle: Text(user['address']),
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Text('Error : ${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
