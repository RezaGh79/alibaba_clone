
import 'dart:convert';

import 'package:alibaba_clone/GlobalVariables.dart';
import 'package:http/http.dart';

  Future<Response> sendGet() async {
    final uri = Uri.parse("${GlobalVariables.BASE_URL}/login");
    final headers = {'Content-Type': 'application/json'};


    Response response = await get(
      uri,
      headers: headers,
    );

    return response;
  }

Future<Response> sendPost() async {
  final uri = Uri.parse("${GlobalVariables.BASE_URL}/login");
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {'username': "reza", 'password': "1234"};
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  return response;
}
