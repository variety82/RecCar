import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bloc_event.dart';
part 'bloc_state.dart';

class Bloc extends Bloc<Event, State> {
  Bloc() : super(Initial()) {
    on<Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}
