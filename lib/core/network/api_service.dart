import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:thrill_quest/app/constant/api/api_endpoints.dart';
import 'package:thrill_quest/app/context/auth_service.dart';
import 'package:thrill_quest/core/network/dio_error_interceptor.dart';
 
class ApiService {
  final Dio _dio;
  // --- MODIFICATION START ---
  // Added AuthService dependency to fetch the token.
  final AuthService _authService;
  // --- MODIFICATION END ---

  Dio get dio => _dio;

  // --- MODIFICATION START ---
  // Updated the constructor to accept AuthService.
  ApiService(this._dio, this._authService) {
  // --- MODIFICATION END ---
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
      // --- MODIFICATION START ---
      // Added a new interceptor to dynamically add the Authorization header.
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // Fetch the token from secure storage.
            final token = await _authService.getToken();
            if (token != null) {
              // Add the Bearer token to the request header.
              options.headers['Authorization'] = 'Bearer $token';
            }
            // Continue with the request.
            return handler.next(options);
          },
        ),
      )
      // --- MODIFICATION END ---
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
  }
}