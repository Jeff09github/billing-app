import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:maaa/presentation/resources/enum.dart';

import '../../../data/model/model.dart';
import '../../../data/repository/repository.dart';

part 'reading_event.dart';
part 'reading_state.dart';

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  final ReadingRepository readingRepository;
  ReadingBloc({required this.readingRepository}) : super(const ReadingSuccess(readings: [])) {
    on<InitialReadingList>(_onInitialReadingList);
    on<LoadReadingList>(_onLoadReadingList);
    on<AddReading>(_onAddReading);
  }

  FutureOr<void> _onLoadReadingList(
    LoadReadingList event,
    Emitter<ReadingState> emit,
  ) async {
    if (kDebugMode) {
      print('on LoadReadingList');
    }
    emit(ReadingLoading());
    try {
      await Future.delayed(const Duration(seconds: 2));
      final _readings = await readingRepository.getReadingList(
          customerId: event.customerId, billType: event.billType);
      emit(ReadingSuccess(readings: _readings));
    } catch (_) {
      emit(ReadingFailure());
    }
  }

  FutureOr<void> _onAddReading(
      AddReading event, Emitter<ReadingState> emit) async {
    if (kDebugMode) {
      print('on AddReading');
    }
    final state = this.state;
    try {
      if (state is ReadingSuccess) {
        await Future.delayed(const Duration(seconds: 2));
        final resultReading =
            await readingRepository.addReading(event.reading, event.customer);
        emit(ReadingSuccess(readings: [...state.readings, resultReading]));
      }
    } catch (_) {
      emit(ReadingFailure());
    }
  }

  FutureOr<void> _onInitialReadingList(
      InitialReadingList event, Emitter<ReadingState> emit) {
    if (kDebugMode) {
      print('on InitialReadingList');
    }
    emit(const ReadingSuccess(readings: []));
  }
}
