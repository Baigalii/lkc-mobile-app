import 'package:flutter/material.dart';
import 'package:lkc/screen/tasks/allocate.dart';
import 'package:lkc/other/guidelines.dart';
import 'package:lkc/screen/login/login.dart';
import 'package:lkc/screen/tasks/modify.dart';
import 'package:lkc/screen/tasks/performance.dart';
import 'package:lkc/screen/tasks/previous.dart';
import 'package:lkc/other/project.dart';
import 'package:lkc/screen/tasks/rearrange.dart';
import 'package:lkc/screen/register/register.dart';
import 'package:lkc/screen/login/resetpass.dart';
import 'package:lkc/screen/tasks/sort.dart';
import 'package:lkc/screen/tasks/task.dart';
import 'package:lkc/screen/tasks/translate.dart';
import 'package:lkc/screen/tasks/validate.dart';

var routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => new LoginApp(),
  "/register": (BuildContext context) => new RegisterApp(),
  "/resetpass": (BuildContext context) => new ResetApp(),
  "/performance": (BuildContext context) => new PerformanceApp(),
  "/task": (BuildContext context) => new TaskApp(),
  "/allocate": (BuildContext context) => new AllocateApp(),
  "/rearrange": (BuildContext context) => new RearrangeApp(),
  "/validate": (BuildContext context) => new ValidateApp(),
  "/translate": (BuildContext context) => new TranslateApp(),
  "/modify": (BuildContext context) => new ModifyApp(),
  "/sort": (BuildContext context) => new SortApp(),
  "/previous": (BuildContext context) => new PreviousApp(),
  "/guidelines": (BuildContext context) => new GuidelineApp(),
  "/project": (BuildContext context) => new ProjectApp(),
};
