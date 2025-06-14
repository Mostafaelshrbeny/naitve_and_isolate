import 'package:equatable/equatable.dart';

class State1 extends Equatable {
  final int count;
  final Map<String, double> data;

  const State1({required this.count, required this.data});
  @override
  List<Object?> get props => [count, data];
  copyWith({int? count, Map<String, double>? data}) =>
      State1(count: count ?? this.count, data: data ?? this.data);
}
