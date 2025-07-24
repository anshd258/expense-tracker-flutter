import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../models/expense_model.dart';
import 'dio_client.dart';

class ExpenseService {
  final DioClient _dioClient;

  ExpenseService(this._dioClient);

  Future<ExpenseListResponse> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    ExpenseCategory? category,
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }
      if (category != null) {
        queryParams['category'] = category.name.toUpperCase();
      }
      if (limit != 0) {
        queryParams['limit'] = limit;
      }
      if (offset != -1) {
        queryParams['offset'] = offset;
      }

      final response = await _dioClient.dio.get(
        ApiConstants.expenses,
        queryParameters: queryParams,
      );

      return ExpenseListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ExpenseModel> createExpense(ExpenseModel expense) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.expenses,
        data: expense.toJson(),
      );
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ExpenseModel> updateExpense(String id, ExpenseModel expense) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.expensesById.replaceAll('{id}', id.toString()),
        data: expense.toJson(),
      );
      return ExpenseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _dioClient.dio.delete(
        ApiConstants.expensesById.replaceAll('{id}', id.toString()),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<CategoryPrediction> predictCategory(String description) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.aiPredictCategory,
        data: {'description': description},
      );
      return CategoryPrediction.fromJson(response.data);
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
