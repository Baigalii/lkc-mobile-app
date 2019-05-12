import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

Future fetchAllocation(int taskType, int gid) async {
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/task/' + taskType.toString() + "/" + gid.toString(), headers: {
    'Content-Type': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

Future getNextTask(String task, int gid, String type) async{
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  String url = 'http://lkc.num.edu.mn/' + task + '/next?domain=' + gid.toString() + '&task=' + type.toString();
  print(url);
  var response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}

Future getPrevTask(String task, int gid, int type) async{
  var prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var response = await http.get('http://lkc.num.edu.mn/' + task.toString() + '/prev?domain=' + gid.toString() + '&task=' + type.toString(), headers: {
    'Content-Type': 'application/json',
    'Authorization': token,
  });
  return jsonDecode(response.body);
}