import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:maaa/presentation/resources/enum.dart';

part 'reading.g.dart';

const String tableReadings = 'readings';

class ReadingField {
  static const String id = 'id';
  static const String customerId = 'customerId';
  static const String reading = 'reading';
  static const String billType = 'billType';
  static const String createdAt = 'createdAt';
}

@JsonSerializable()
class Reading extends Equatable {
  final int? id;
  final int customerId;
  final String reading;
  final BillType billType;
  final DateTime createdAt;

  const Reading({
    this.id,
    required this.customerId,
    required this.reading,
    required this.billType,
    required this.createdAt,
  });

  factory Reading.fromJson(Map<String, dynamic> json) =>
      _$ReadingFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingToJson(this);

  Reading copy(
          {int? id,
          int? customerId,
          String? reading,
          BillType? billType,
          DateTime? createdAt}) =>
      Reading(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        reading: reading ?? this.reading,
        billType: billType ?? this.billType,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        customerId,
        reading,
        billType,
        createdAt,
      ];
}
