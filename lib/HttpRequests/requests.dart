
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
  Map<String, dynamic> body = {'travelId': "reza", 'token': "1234"};
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');


  //{
  //     "travelId": "18",
  //     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InphaHJhIiwic3ViIjo0MSwiaWF0IjoxNjg0Mzk4NDU3LCJleHAiOjE2ODUwMDMyNTd9.JAfo09lCNU7FNgw7hsueVUZNhzt2GDxLM00cnCSG9f4",
  //     "seat_reserved": {
  //         "9": "0521365987",
  //         "13": "0523698547"
  //     }
  // }

  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );

  return response;
}
