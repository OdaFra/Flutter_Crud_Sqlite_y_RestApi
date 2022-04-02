import 'package:devmobiletest/src/models/users.dart';
import 'package:devmobiletest/src/pages/userDetalles.dart';
import 'package:devmobiletest/src/services/api.dart';
import 'package:flutter/material.dart';

class DetalleApiPage extends StatefulWidget {
  @override
  State<DetalleApiPage> createState() => _DetalleApiPageState();
}

class _DetalleApiPageState extends State<DetalleApiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Reqres Api"),
          centerTitle: true,
        ),
        body: FutureBuilder<List<UsersModel>>(
          future: ApiService().getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  ...snapshot.data!.map((user) => InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserDetallesPage(
                              user: user,
                            ),
                          ),
                        ),
                        child: Card(
                          color: Colors.blue.shade500,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ListTile(
                            title: Text(
                              user.firstname,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              user.lastname,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: CircleAvatar(
                              backgroundImage: NetworkImage(user.avatar),
                            ),
                          ),
                        ),
                      ))
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
