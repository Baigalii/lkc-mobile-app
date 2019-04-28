import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lkc/words.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future fetchPerformance() async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/performance', headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

Future fetchProfile() async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/user/profile', headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

Future<List> fetchTask(int type) async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await
    http.get('http://lkc.num.edu.mn/domain?taskType=' + type.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token,
          });
  return jsonDecode(response.body);
}

Future fetchAllocation(int gid) async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/task/1/' + gid.toString(), headers: {
    'Content-Type': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

Future getNextTask(int gid, int type) async{
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/translation/next?domain=' + gid.toString() + '&task=' + type.toString(), headers: {
    'Content-Type': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

Future fetchModification(int gid) async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await
    http.get('http://lkc.num.edu.mn/task/2/' +gid.toString(),
        headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      });
  return jsonDecode(response.body);
}

Future fetchValidation(int gid) async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/task/3/' +gid.toString(), headers: {
    'Content-Type': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

Future fetchTranslation(int gid) async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/task/4/' +gid.toString(), headers: {
    'Content-Type': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

Future fetchRevise(int gid) async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/task/5/' +gid.toString(), headers: {
    'Content-Type': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

Future fetchSort(int gid) async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/task/6/' +gid.toString(), headers: {
    'Content-Type': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

//// A function that will convert a response body into a List<Word>
//List<Word> parseData(String responseBody) {
//  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//  List<Word> list = parsed.map<Word>((json) => new Word.fromJson(json)).toList();
//  return list;
//}