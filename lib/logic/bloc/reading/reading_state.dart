part of 'reading_bloc.dart';

abstract class ReadingState extends Equatable {
  const ReadingState();

  @override
  List<Object> get props => [];
}

class ReadingLoading extends ReadingState {}

class ReadingSuccess extends ReadingState {
  final List<Reading> readings;

  const ReadingSuccess({required this.readings});
}

class ReadingFailure extends ReadingState {}
