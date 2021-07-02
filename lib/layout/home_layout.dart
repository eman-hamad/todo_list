import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/module/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_list/module/done_tasks/done_tasks_screen.dart';
import 'package:todo_list/module/new_tasks/new_tasks_screen.dart';
import 'package:todo_list/shared/components/components.dart';
import 'package:todo_list/shared/components/constants.dart';
import 'package:todo_list/shared/cubit/cubit.dart';
import 'package:todo_list/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
// To use sqflite :

  // 1- create database
  // 2- create tables
  // 3- open database
  // 4- insert to database
  // 5- get from database
  // 6- update in database
  // 7- delete from database

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  final task_Color = Color(0xffEF9731);
  final background_Color = Color(0xff171932);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            backgroundColor: background_Color,
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.app_bar_title[cubit.current]),
              
            ),
            // by conditional builder package
            body: 
            ConditionalBuilder(
              condition: state is ! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.current],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),

            //or .. by inline if >>
            //body: tasks.length==0 ? Center(child: CircularProgressIndicator()) : screens[current],
            floatingActionButton: FloatingActionButton(
              
              backgroundColor: task_Color,
              onPressed: () {
                /*try {
                // throw ("some erorr !!");

                // if removed "await" ==> return >> Instance of 'Future<String>'

                var result = await getName();
                print(result);
              } catch (error) {
                print("error ${error.toString()}");
              }

              // or use then methode and catch error >> confirm that getName() finished but in try catch not confirm "sure"

              /* getName().then((value) {
                print(value);
                print("EMO");
                throw ("errrrrrrrrror");
              }).catchError((error) {
                print("error ${error.toString()}");
              });*/
              */

                if (cubit.isButtomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20.0),
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'title must not be empty';
                                    }

                                    return null;
                                  },
                                  text: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                    isClickable: true,
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Date must not be empty';
                                      }

                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2021-12-30'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                        print(DateFormat.yMMMd().format(value));
                                        // form itl package to change date formate
                                      });
                                      print("Date tapped");
                                    },
                                    text: 'Task Date',
                                    prefix: Icons.calendar_today_outlined),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                    isClickable: true,
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Time must not be empty';
                                      }

                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value.format(context).toString();
                                        print(value.format(context));
                                      });
                                      print("Timing tapped");
                                    },
                                    text: 'Task Time',
                                    prefix: Icons.watch_later_outlined),
                              ],
                            ),
                          ),
                        ),
                        elevation: 30.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShown: false, icon: Icons.edit);

                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  });

                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });

                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
                
                
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: task_Color,
              selectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.current,
              onTap: (index) {
                // setState(() {
                //   current = index;
                // });

                AppCubit.get(context).ChangeIndex(index);
                print(index);
              },
              items: [
                BottomNavigationBarItem(
                  
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
