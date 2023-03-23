import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'blocs_event.dart';
part 'blocs_state.dart';

class sBloc extends Bloc<sEvent, sState> {
  sBloc() : super(sInitial()) {
    on<sEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
