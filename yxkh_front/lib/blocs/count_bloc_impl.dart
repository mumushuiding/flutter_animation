import 'package:rxdart/rxdart.dart';

import 'count_bloc.dart';

class CountBlocImpl implements CountBloc{
  int _count=0;
  var _suject=BehaviorSubject<int>();
  
  @override
  void dispose() {
    _suject.close(); 
  }

  @override
  void increment() {
    _suject.add(++_count);
    print("count:$_count");
  }

  @override
  
  Stream<int> get stream => _suject.stream;

  @override
 
  int get value => _count;
  
}