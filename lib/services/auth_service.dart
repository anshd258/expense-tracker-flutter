import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import 'dio_client.dart';

class AuthService {
  final DioClient _dioClient;

  AuthService(this._dioClient);

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.authLogin,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _dioClient.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      await _dioClient.dio.post(
        ApiConstants.authRegister,
        data: request.toJson(),
      );
      // After successful registration, log in with the same credentials
      final loginRequest = LoginRequest(
        email: request.email,
        password: request.password,
      );
      final authResponse = await login(loginRequest);
      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await _dioClient.clearTokens();
  }

  Future<bool> isAuthenticated() async {
    final token = await _dioClient.getToken();
    return token != null;
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _dioClient.dio.get('/auth/me');
      return UserModel.fromJson(response.data);
    } catch (e) {
      return null;
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
