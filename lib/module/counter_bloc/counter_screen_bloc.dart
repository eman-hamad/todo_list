import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/module/counter_bloc/cubit/cubit.dart';
import 'package:todo_list/module/counter_bloc/cubit/states.dart';

// stateless contains 1 class provide widget

// stateful contains 2 classes

//1. class provide widget
//2. class provide state from this widget

class CounterScreen extends StatelessWidget {
  //class provide widget

  int count = 0;

  //calling

  // 1.constructor
  // 2.init state  methode "hidden"  "initial state"
  // 3. build methode

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterStates>(
        //listen to changes
        listener: (context, state) {
          if (state is CounterAddState) {
            print("Counter Add State ${state.counter}");
          }

          if (state is CounterMinusState) {
            print("Counter Minus State ${state.counter}");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Counter"),
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        CounterCubit.get(context).minus();
                      },
                      child: Text("SUB",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ))),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                    ),
                    child: Text("${CounterCubit.get(context).counter}",
                        style: TextStyle(
                          fontSize: 65,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  TextButton(
                      onPressed: () {
                        CounterCubit.get(context).add();
                      },
                      child: Text("ADD",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
