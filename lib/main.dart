import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/layout/home_layout.dart';
import 'package:todo_list/shared/bloc_observer.dart';


import 'module/counter_bloc/counter_screen_bloc.dart';





void main() {
  //to use bloc observer to observe states
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   final task_Color = Color(0xffEF9731);
  final background_Color = Color(0xff171932);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(backgroundColor: task_Color)
      ),
      home: HomeLayout(),
    );
  }
}

