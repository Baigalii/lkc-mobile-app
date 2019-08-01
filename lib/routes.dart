import 'package:flutter/material.dart';
import 'package:lkc/allocate.dart';
import 'package:lkc/guidelines.dart';
import 'package:lkc/login.dart';
import 'package:lkc/modify.dart';
import 'package:lkc/performance.dart';
import 'package:lkc/previous.dart';
import 'package:lkc/project.dart';
import 'package:lkc/rearrange.dart';
import 'package:lkc/register.dart';
import 'package:lkc/resetpass.dart';
import 'package:lkc/sort.dart';
import 'package:lkc/task.dart';
import 'package:lkc/translate.dart';
import 'package:lkc/validate.dart';

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
