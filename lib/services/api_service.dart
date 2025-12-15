import 'package:dio/dio.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mycar/models/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio = Dio(
  BaseOptions(
    baseUrl: GlobalConfiguration().get("api"),
  ),
);

class ApiService {
  static Future<ResponseModel> get(
    String path, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      print("🌐 GET $path");
      print("📦 Query Params: $queryParams");
      
      final sh = await SharedPreferences.getInstance();
      final resp = await dio.get(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "fcmToken": "${sh.getString("fcm")}",
            "lat": "${sh.getDouble("lat")}",
            "lng": "${sh.getDouble("lng")}",
          },
        ),
      );
      
      print("✅ GET $path - Status: ${resp.statusCode}");
      print("✅ Response: ${resp.data}");
      
      return ResponseModel.fromMap(resp.data);
    } catch (e) {
      print("❌ GET $path - Error: $e");
      if (e is DioException) {
        print("❌ Status Code: ${e.response?.statusCode}");
        print("❌ Response Data: ${e.response?.data}");
        
        if (e.response?.data != null && e.response?.data is! String) {
          return ResponseModel.fromMap(e.response?.data);
        } else {
          return ResponseModel(
            success: false,
            data: null,
            total: 0,
            message: e.message,
          );
        }
      } else {
        return ResponseModel(
          success: false,
          data: null,
          total: 0,
          message: "network_error",
        );
      }
    }
  }

  static Future<ResponseModel> delete(
    String path, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      print("🌐 DELETE $path");
      print("📦 Query Params: $queryParams");
      
      final resp = await dio.delete(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      
      print("✅ DELETE $path - Status: ${resp.statusCode}");
      print("✅ Response: ${resp.data}");
      
      return ResponseModel.fromMap(resp.data);
    } catch (e) {
      print("❌ DELETE $path - Error: $e");
      if (e is DioException) {
        print("❌ Status Code: ${e.response?.statusCode}");
        print("❌ Response Data: ${e.response?.data}");
        
        if (e.response?.data != null && e.response?.data is! String) {
          return ResponseModel.fromMap(e.response?.data);
        } else {
          return ResponseModel(
            success: false,
            data: null,
            total: 0,
            message: e.message,
          );
        }
      } else {
        return ResponseModel(
          success: false,
          data: null,
          total: 0,
          message: "network_error",
        );
      }
    }
  }

  static Future<ResponseModel> post(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      print("🌐 POST $path");
      print("📦 Data: $data");
      print("📦 Query Params: $queryParams");
      
      final resp = await dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      
      print("✅ POST $path - Status: ${resp.statusCode}");
      print("✅ Response: ${resp.data}");
      
      return ResponseModel.fromMap(resp.data);
    } catch (e) {
      print("❌ POST $path - Error: $e");
      if (e is DioException) {
        print("❌ Status Code: ${e.response?.statusCode}");
        print("❌ Response Data: ${e.response?.data}");
        
        if (e.response?.data != null && e.response?.data is! String) {
          return ResponseModel.fromMap(e.response?.data);
        } else {
          return ResponseModel(
            success: false,
            data: null,
            total: 0,
            message: e.message,
          );
        }
      } else {
        return ResponseModel(
          success: false,
          data: null,
          total: 0,
          message: "network_error",
        );
      }
    }
  }

  static Future<ResponseModel> put(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      print("🌐 PUT $path");
      print("📦 Data: $data");
      print("📦 Query Params: $queryParams");
      
      final resp = await dio.put(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      
      print("✅ PUT $path - Status: ${resp.statusCode}");
      print("✅ Response: ${resp.data}");
      
      return ResponseModel.fromMap(resp.data);
    } catch (e) {
      print("❌ PUT $path - Error: $e");
      if (e is DioException) {
        print("❌ Status Code: ${e.response?.statusCode}");
        print("❌ Response Data: ${e.response?.data}");
        
        if (e.response?.data != null && e.response?.data is! String) {
          return ResponseModel.fromMap(e.response?.data);
        } else {
          return ResponseModel(
            success: false,
            data: null,
            total: 0,
            message: e.message,
          );
        }
      } else {
        return ResponseModel(
          success: false,
          data: null,
          total: 0,
          message: "network_error",
        );
      }
    }
  }

  static Future<ResponseModel> postFormdata(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      print("🌐 POST (FormData) $path");
      print("📦 Data Keys: ${data.keys.toList()}"); // Don't print full data, files are too large
      print("📦 Query Params: $queryParams");
      
      final resp = await dio.post(
        path,
        data: FormData.fromMap(data),
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      
      print("✅ POST (FormData) $path - Status: ${resp.statusCode}");
      print("✅ Response: ${resp.data}");
      
      return ResponseModel.fromMap(resp.data);
    } catch (e) {
      print("❌ POST (FormData) $path - Error: $e");
      if (e is DioException) {
        print("❌ Status Code: ${e.response?.statusCode}");
        print("❌ Response Data: ${e.response?.data}");
        
        if (e.response?.data != null && e.response?.data is! String) {
          return ResponseModel.fromMap(e.response?.data);
        } else {
          return ResponseModel(
            success: false,
            data: null,
            total: 0,
            message: e.message,
          );
        }
      } else {
        return ResponseModel(
          success: false,
          data: null,
          total: 0,
          message: "network_error",
        );
      }
    }
  }

  static Future<ResponseModel> putFormdata(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParams,
    String? token,
  }) async {
    try {
      print("🌐 PUT (FormData) $path");
      print("📦 Data Keys: ${data.keys.toList()}");
      print("📦 Query Params: $queryParams");
      
      final resp = await dio.put(
        path,
        data: FormData.fromMap(data),
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      
      print("✅ PUT (FormData) $path - Status: ${resp.statusCode}");
      print("✅ Response: ${resp.data}");
      
      return ResponseModel.fromMap(resp.data);
    } catch (e) {
      print("❌ PUT (FormData) $path - Error: $e");
      if (e is DioException) {
        print("❌ Status Code: ${e.response?.statusCode}");
        print("❌ Response Data: ${e.response?.data}");
        
        if (e.response?.data != null && e.response?.data is! String) {
          return ResponseModel.fromMap(e.response?.data);
        } else {
          return ResponseModel(
            success: false,
            data: null,
            total: 0,
            message: e.message,
          );
        }
      } else {
        return ResponseModel(
          success: false,
          data: null,
          total: 0,
          message: "network_error",
        );
      }
    }
  }
}