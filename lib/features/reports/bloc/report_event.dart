import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class ReportDataRequested extends ReportEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String? category;

  const ReportDataRequested({
    required this.startDate,
    required this.endDate,
    this.category,
  });

  @override
  List<Object?> get props => [startDate, endDate, category];
}

class ReportFilterChanged extends ReportEvent {
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportFilterChanged({
    this.category,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [category, startDate, endDate];
}

class ReportTypeChanged extends ReportEvent {
  final ReportType reportType;

  const ReportTypeChanged(this.reportType);

  @override
  List<Object?> get props => [reportType];
}

enum ReportType {
  daily,
  weekly,
  monthly,
}