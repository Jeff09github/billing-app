part of 'reading_bloc.dart';

abstract class ReadingEvent extends Equatable {
  const ReadingEvent();

  @override
  List<Object> get props => [];
}

class InitialReadingList extends ReadingEvent {}

class LoadReadingList extends ReadingEvent {
  final int customerId;
  final BillType billType;

  const LoadReadingList({required this.customerId, required this.billType});

  @override
  List<Object> get props => [customerId, billType];
}

class AddReading extends ReadingEvent {
  final Reading reading;
  final Customer customer;

  const AddReading({
    required this.reading,
    required this.customer,
  });

  @override
  List<Object> get props => [reading, customer];
}
