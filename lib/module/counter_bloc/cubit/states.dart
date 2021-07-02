abstract class CounterStates {}

class CounterInitialState extends CounterStates {}

class CounterAddState extends CounterStates {
  final int counter;
  CounterAddState(this.counter);
}

class CounterMinusState extends CounterStates {
  final int counter;
  CounterMinusState(this.counter);
}
