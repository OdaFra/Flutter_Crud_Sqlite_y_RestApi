import 'dart:convert';
import 'package:devmobiletest/src/models/users.dart';
import 'package:http/http.dart';

class ApiService {
  String endpoint = 'https://reqres.in/api/users?page=1';

  Future<List<UsersModel>> getUser() async {
    Response response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      return result.map(((e) => UsersModel.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
