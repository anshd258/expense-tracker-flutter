import 'package:dio/dio.dart';
import 'dart:typed_data';
import '../core/constants/api_constants.dart';
import '../models/report_model.dart';
import 'dio_client.dart';

class ReportService {
  final DioClient _dioClient;

  ReportService(this._dioClient);

  Future<DailyReportResponse> getDailyReport(DateTime date) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.reportsDaily,
        queryParameters: {
          'date': date.toIso8601String().split('T')[0],
        },
      );
      return DailyReportResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<WeeklyReportResponse> getWeeklyReport({DateTime? startDate}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }

      final response = await _dioClient.dio.get(
        ApiConstants.reportsWeekly,
        queryParameters: queryParams,
      );
      return WeeklyReportResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<MonthlyReportResponse> getMonthlyReport({
    int? year,
    int? month,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (year != null) queryParams['year'] = year;
      if (month != null) queryParams['month'] = month;

      final response = await _dioClient.dio.get(
        ApiConstants.reportsMonthly,
        queryParameters: queryParams,
      );
      return MonthlyReportResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Legacy method for compatibility if needed
  Future<ReportModel> getReport({
    required DateTime startDate,
    required DateTime endDate,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate.toIso8601String().split('T')[0],
      };
      if (category != null) queryParams['category'] = category;

      final response = await _dioClient.dio.get(
        '${ApiConstants.reports}/detailed',
        queryParameters: queryParams,
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Uint8List> exportToCsv({
    DateTime? startDate,
    DateTime? endDate,
    String? reportType,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
      }
      if (reportType != null) {
        queryParams['report_type'] = reportType;
      }

      final response = await _dioClient.dio.get<List<int>>(
        ApiConstants.reportsExportCsv,
        queryParameters: queryParams,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Accept': 'text/csv',
          },
        ),
      );

      return Uint8List.fromList(response.data!);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
    }
    return error.message ?? 'An error occurred';
  }
}