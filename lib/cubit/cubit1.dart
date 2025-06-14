import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:isolation_and_naitve/cubit/state1.dart';
import 'package:isolation_and_naitve/naitve_integration.dart';

class SensorCubit extends Cubit<State1> {
  static const _sensorChannel =
      EventChannel('com.example.naitveintegrationexample/sensor');
  StreamSubscription? _subscription;

  SensorCubit() : super(State1(count: 0, data: {})) {
    _startListening();
  }

  void _startListening() {
    _subscription = _sensorChannel.receiveBroadcastStream().listen((event) {
      final data = Map<String, double>.from(event);
      emit(state.copyWith(data: data));
    });
  }

  count() async {
    final result = await IntergartionFunctions.counter(state.count);
    emit(state.copyWith(count: result));
  }

  heavyNaitve() async {
    final result = await IntergartionFunctions.heavyFunction();
    log(result.toString());
  }

  heavyNaitveWithIsolatedThreads() async {
    final result = await IntergartionFunctions.heavyLoopWithThread();
    log(result.toString());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
