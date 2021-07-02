import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/module/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_list/module/done_tasks/done_tasks_screen.dart';
import 'package:todo_list/module/new_tasks/new_tasks_screen.dart';
import 'package:todo_list/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  // carry all logic
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int current = 0;
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  bool isButtomSheetShown = false;
  IconData fabIcon = Icons.edit;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> app_bar_title = ["New Tasks", "Done Tasks", "Archived Tasks"];

  void ChangeIndex(index) {
    current = index;
    emit(AppChangeBottomNavBarState());
  }

  // create database

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      // version changes when table structure is changed

      onCreate: (database, version) {
        print("database created");

        // id int
        // title string
        // date
        // time string
        // status string

        database
            .execute(
                'CREATE TABLE Tasks(id INTEGER PRIMARY KEY , title Text,date Text ,time Text ,status Text  ) ')
            .then((value) {
          print("TABLES created");
        }).catchError((error) {
          print("error when creating table ${error.toString()}");
        });
      },
      onOpen: (database) {
        getFromDatabase(database);
        // catchError((error) {
        //   print("error when getting data form database ${error.toString()}");
        // });
        print("database opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required title,
    @required date,
    @required time,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO Tasks ( title , date , time , status ) VALUES ( "${title}" , "${date} " , "${time} " , "new") ')
          .then((value) {
        print("$value inserted successfully");

        emit(AppInsertDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print("error when insert into new row ${error}");
      });
      return null;
    });
  }

  void getFromDatabase(database) {
     newTasks = [];
     doneTasks = [];
     archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks ').then((value) {
      // setState(() {
      //   tasks = value;
      // });

      print(value);
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }

        print(element['status']);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({

    @required String status,
    @required int id
  }) async {
    
    database.rawUpdate('UPDATE Tasks SET status = ?  WHERE id = ?',
        [status, '$id']).then((value) {
      getFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }



    void deleteDatabase({
    @required int id
      }) async {
    
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeBottomSheetState({
    @required bool isShown,
    @required IconData icon,
  }) {
    isButtomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
