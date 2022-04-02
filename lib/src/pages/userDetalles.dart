import 'package:devmobiletest/src/models/users.dart';
import 'package:flutter/material.dart';

class UserDetallesPage extends StatefulWidget {
  UserDetallesPage({Key? key, required this.user}) : super(key: key);
  UsersModel user;

  @override
  _UserDetallesPageState createState() => _UserDetallesPageState();
}

class _UserDetallesPageState extends State<UserDetallesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Detalle"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: CircleAvatar(
                maxRadius: 60,
                backgroundImage: NetworkImage(widget.user.avatar),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.user.firstname + " " + widget.user.lastname,
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.user.email),
          ],
        ),
      ),
    );
  }
}
