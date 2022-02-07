// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables

//import 'package:conditional/conditional.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
//import 'package:intl/intl_standalone.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
//import 'package:conditional_builder/conditional_builder.dart';
//import 'package:conditional/conditional.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  @override
  late Database database;
  IconData floatIcon = Icons.edit;
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  //var titleController=GlobalKey<FormState>();
  //final titleKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
        //if(state is AppChangeBottomNaveBarState)print('AppChangeBottomNaveBarState');
      }, builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          key: scaffoldkey,
          body: false
              ? Center(child: CircularProgressIndicator())
              : cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            child: Icon(cubit.fabIcon),
            onPressed: () {
              if (cubit.isBottomSheet) {
                if (_formKey.currentState?.validate() ?? false) {
                  //_formKey.currentState!.validate();
                    cubit.insertToDatabase(
                          title: titlecontroller.text,
                          date: datecontroller.text,
                          time: timecontroller.text)
                      .then((value) {
                    print('$value inserted Succefully');
                    Navigator.pop(context);
                    cubit.changeFloatingActionButton(false, Icons.edit);
                  }); 
                }
              } else {
                scaffoldkey.currentState!
                    .showBottomSheet((context) => Container(
                          padding: EdgeInsets.all(20),
                          //color: Colors.grey[100],
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                    //key: titleKey,
                                    controller: titlecontroller,
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      // ignore: avoid_print
                                      print(value);
                                    },
                                    onChanged: (value) {
                                      // ignore: avoid_print
                                      print(value);
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Task Title',
                                      prefixIcon: Icon(
                                        Icons.text_fields_outlined,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (String? value) {
                                      if (value!.length < 1)
                                        return 'Please Enter the Title';
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                    //key: _formKey,
                                    controller: timecontroller,
                                    keyboardType: TextInputType.datetime,
                                    onFieldSubmitted: (value) {
                                      // ignore: avoid_print
                                      print(value);
                                    },
                                    onChanged: (value) {
                                      // ignore: avoid_print
                                      print(value);
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timecontroller.text =
                                            value!.format(context).toString();
                                      }).catchError((error) {});
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Time',
                                      prefixIcon: Icon(
                                        Icons.timelapse_rounded,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (String? value) {
                                      if (value!.length < 1)
                                        return 'Please Enter the Title';
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                    //key: _formKey,
                                    controller: datecontroller,
                                    keyboardType: TextInputType.datetime,
                                    onFieldSubmitted: (value) {
                                      // ignore: avoid_print
                                      print(value);
                                    },
                                    onChanged: (value) {
                                      // ignore: avoid_print
                                      print(value);
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2023-01-01'))
                                          .then((value) {
                                        datecontroller.text =
                                            DateFormat.yMMMd().format(value!);
                                        print(datecontroller.text);
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Date',
                                      prefixIcon: Icon(
                                        Icons.calendar_today,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (String? value) {
                                      if (value!.length < 1)
                                        return 'Please Enter the Task Date';
                                      return null;
                                    }),
                              ],
                            ),
                          ),
                        ))
                    .closed
                    .then((value) {
                  //floatIcon = Icons.edit;
                  //cubit.isBottomSheet = !cubit.isBottomSheet;
                  cubit.changeFloatingActionButton(false, Icons.edit);
                });
                //floatIcon = Icons.add;
                //cubit.isBottomSheet = !cubit.isBottomSheet;
                cubit.changeFloatingActionButton(true, Icons.add);
              }
            },
            elevation: 20,
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline_outlined),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archive'),
              ]),
        );
      }),
    );
  }

  /* Future<void> createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('tables Created succefully');
        }).catchError((error) {
          print('error ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('$database database opened');
        getdatafromDB(database).then((value) {
          tasks = value;
          print(tasks);
          print('Tasks length is $tasks.length');
        });
      },
    );
  }

  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    database.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")');
    }).then((value) {
      print('$value inserted succefully');
    }).catchError((error) {
      print('error when inserting data ${error.toString()} ');
    });
  }

  Future<List<Map>> getdatafromDB(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
    //print(tasks);
  } */
}
