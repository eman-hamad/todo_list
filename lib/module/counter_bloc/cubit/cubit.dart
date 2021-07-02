import 'package:bloc/bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/module/counter_bloc/cubit/states.dart';

class CounterCubit extends Cubit<CounterStates> {
  // form bloc package

  CounterCubit() : super(CounterInitialState());

// now can use this cubit in many places .. return object of CounterCubit carry counter ,....
  static CounterCubit get(context) => BlocProvider.of(context);

  int counter = 1;

  void add() {
    counter++;
    emit(CounterAddState(counter));
    //emit ..> send it 
  }

  void minus() {
    counter--;
    emit(CounterMinusState(counter));
  }
}
