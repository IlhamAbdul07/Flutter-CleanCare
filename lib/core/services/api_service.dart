import 'dart:convert';
import 'dart:developer';
import 'package:flutter_cleancare/core/routes/app_pages.dart';
import 'package:flutter_cleancare/core/services/general_service.dart';
import 'package:flutter_cleancare/core/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const String baseUrl = "https://yusnar.my.id/go-cleancare";

class ApiService {
  
  // ============================== API REQUEST ============================== //
  static Future<Map<String, dynamic>?> apiRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    List<http.MultipartFile> listFile = const [],
    String? token,
    String contentType = 'application/json',
  }) async {
    // init
    http.Response response;
    final url = '$baseUrl$endpoint';
    Map<String, String> header = {'Content-Type': contentType};

    if (token != null) {
      header['Authorization'] = 'Bearer $token';
    }

    try {
      // function hit api
      Future<http.Response> hitAPI() async {
        switch (method.toUpperCase()) {
          case 'POST':
            if (contentType == 'application/json') {
              return http.post(
                Uri.parse(url),
                headers: header,
                body: jsonEncode(body),
              );
            }
            return _handleMultipartRequest(method, url, header, listFile, body);
          case 'GET':
            return http.get(Uri.parse(url), headers: header);
          case 'PUT':
            if (contentType == 'application/json') {
              return http.put(
                Uri.parse(url),
                headers: header,
                body: jsonEncode(body),
              );
            }
            return _handleMultipartRequest(method, url, header, listFile, body);
          case 'DELETE':
            return http.delete(Uri.parse(url), headers: header);
          case 'PATCH':
            return contentType == 'application/json'
                ? http.patch(
                    Uri.parse(url),
                    headers: header,
                    body: jsonEncode(body),
                  )
                : await _handleMultipartRequest(
                    method,
                    url,
                    header,
                    listFile,
                    body,
                  );
          default:
            throw Exception('Unsupported HTTP method: $method');
        }
      }

      // hit api
      response = await hitAPI();
      // cek if refresh token needed
      final isAuthEndpoint = [
        "/auth/login",
        "/auth/logout",
        "/auth/send-email/forgot-password",
        "/auth/verify-number",
        "/auth/register",
      ];
      if (response.statusCode == 401 && !isAuthEndpoint.contains(endpoint)) {
        final newToken = await _refreshToken(token);
        if (newToken != null) {
          header['Authorization'] = 'Bearer $newToken';
          response = await hitAPI();
        } else {
          await _handleExpiredSession();
          throw Exception("Session Expired");
        }
      } else if (response.statusCode == 422 && !isAuthEndpoint.contains(endpoint)) {
        await _handleExpiredSession();
        throw Exception("Session Expired");
      }

      // return body
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return jsonBody;
    } catch (e, trace) {
      debugPrint("trace :>>> $trace");
      // return null;
      rethrow;
    }
  }


  // ============================== API REQUEST (PRIVATE FUNCTION) ============================== //
  static Future<http.Response> _handleMultipartRequest(
    String method,
    String url,
    Map<String, String> header,
    List<http.MultipartFile> listFile,
    Map<String, dynamic>? body,
  ) async {
    var request = http.MultipartRequest(method, Uri.parse(url))
      ..headers.addAll(header);
    body?.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.files.addAll(listFile);
    return await http.Response.fromStream(await request.send());
  }

  static Future<String?> _refreshToken(String? token) async {
    log("Hit refresh token...");
    try {
      final response = await authRefeshToken(token!);
      if (response!['success'] == true) {
        final newToken = response['data']['token'];
        StorageService.setToken(newToken);
        final token = StorageService.getToken();
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> _handleExpiredSession() async {
    try {
      final storedToken = StorageService.getToken();
      if (storedToken != null) {
        await apiRequest(
          method: 'POST',
          endpoint: '/auth/logout',
          body: null,
          token: storedToken,
          contentType: 'application/json',
        );
      }
    } catch (e) {
      debugPrint("Error when auto logout: $e");
    } finally {
      StorageService.clearAll();
      Get.offAllNamed(Routes.login);
    }
  }


  // ============================== AUTH ============================== //
  static Future<Map<String, dynamic>?> authLogin(
    String numberId,
    String password,
  ) async {
    final response = await apiRequest(
      method: 'POST',
      endpoint: '/auth/login',
      body: {'number_id': numberId, 'password': password,},
      token: null,
      contentType: 'application/json',
    );

    return response;
  }

  static Future<Map<String, dynamic>?> authRefeshToken(String token) async {
    final url = '$baseUrl/auth/refresh-token';
    Map<String, String> header = {'Content-Type': 'application/json'};
    header['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse(url),
      body: null,
      headers: header,
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    return jsonBody;
  }

  static Future<void> authLogout() async {
    final token = StorageService.getToken();

    try {
      final response = await apiRequest(
        method: 'POST',
        endpoint: '/auth/logout',
        body: null,
        token: token,
        contentType: 'application/json',
      );

      if (response != null && response['code'] == 200) {
        StorageService.clearAll();
      } else {
        debugPrint("Logout API gagal: ${response?['code']}");
        StorageService.clearAll();
      }
    } catch (e) {
      debugPrint("Error when logout: $e");
    }
  }

  static Future<Map<String, dynamic>?> sendForgotPasswordEmail(
    String email,
  ) async {
    try {
      final response = await apiRequest(
        method: 'POST',
        endpoint: '/auth/send-email/forgot-password',
        body: {'email': email},
        token: null,
        contentType: 'application/json',
      );

      if (response != null && response['code'] == 401) {
        return {'success': false, 'message': 'Email tidak terdaftar'};
      }
      return response;
    } catch (e) {
      debugPrint('Error when sent email reset: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat mengirim email reset: $e',
      };
    }
  }

  static Future<Map<String, dynamic>?> authVerifyNumber(
    String numberId,
  ) async {
    final response = await apiRequest(
      method: 'POST',
      endpoint: '/auth/verify-number',
      body: {'number_id': numberId},
      token: null,
      contentType: 'application/json',
    );

    return response;
  }

  static Future<Map<String, dynamic>?> authRegister(
    Map<String, dynamic>? data,
    List<http.MultipartFile> listFile,
  ) async {
    final response = await apiRequest(
      method: 'POST',
      endpoint: '/auth/register',
      body: data,
      token: null,
      listFile: listFile,
      contentType: 'multipart/form-data',
    );

    return response;
  }


  // ============================== MASTER DATA (USER) ============================== //
  static Future<dynamic> handleUser({
    required String method,
    int? userId,
    Map<String, dynamic>? data,
    String? contentType = "application/json",
    Map<String, String>? params,
    List<http.MultipartFile> listFile = const [],
  }) async {
    final token = StorageService.getToken();

    String endpoint;
    if (method == 'GET') {
      endpoint = '/user${userId != null ? "/$userId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/user';
    } else if (method == 'PUT' && userId != null) {
      endpoint = '/user/$userId';
    } else if (method == 'PATCH' && userId != null) {
      endpoint = '/user/change-password/$userId';
    } else if (method == 'DELETE' && userId != null) {
      endpoint = '/user/$userId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      listFile: listFile,
      contentType: contentType!,
    );

    return response;
  }

  
  // ============================== CMS ============================== //
  static Future<Map<String, dynamic>?> fetchDashboard(String token) async {
    final response = await apiRequest(
      method: 'GET',
      endpoint: '/crm/access/count', // Endpoint yang benar
      body: null,
      token: token,
      contentType: 'application/json',
    );
    return response;
  }

  static Future<Map<String, dynamic>?> handleContacts({
    required String token,
    int? contactId,
    Map<String, String>?
    params, // Query Parameters seperti {'page': '1', 'limit': '10'}
  }) async {
    // Bangun endpoint dengan optional contactId dan query params
    String endpoint =
        '/crm/contact${contactId != null ? "/$contactId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';

    final response = await apiRequest(
      method: 'GET',
      endpoint: endpoint,
      body: null,
      token: token,
      contentType: 'application/json',
    );

    if (response == null ||
        response['success'] != true ||
        response['code'] != 200) {
      throw Exception(
        "Gagal mengambil data kontak. Pesan: ${response?['message']}",
      );
    }

    try {
      try {
        final encodeValue = json.encode(response);
        log(encodeValue, name: endpoint);
      } catch (e) {}

      // Ambil bagian utama dari data response
      final responseData = response['data'];

      if (contactId != null) {
        // Jika mengambil data satu kontak berdasarkan ID
        final contactData = (responseData['data'] as List).isNotEmpty
            ? responseData['data'][0]
            : {};
        return {'data': contactData, 'count': contactData.isNotEmpty ? 1 : 0};
      } else {
        // Jika mengambil semua kontak
        final List<Map<String, dynamic>> contactsList =
            List<Map<String, dynamic>>.from(responseData['data']);
        final int count = responseData['count'] ?? 0;

        return {'data': contactsList, 'count': count};
      }
    } catch (e, stacktace) {
      debugPrint("stacktace : $stacktace");
    }
    return null;
  }

  static Future<Map<String, dynamic>?> handleAffiliates({
    required String token,
    int? affiliateId,
    Map<String, String>?
    params, // Query Parameters seperti {'page': '1', 'limit': '10'}
  }) async {
    // Bangun endpoint dengan optional contactId dan query params
    String endpoint =
        '/crm/affiliate${affiliateId != null ? "/$affiliateId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';

    final response = await apiRequest(
      method: 'GET',
      endpoint: endpoint,
      body: null,
      token: token,
      contentType: 'application/json',
    );

    if (response == null ||
        response['success'] != true ||
        response['code'] != 200) {
      throw Exception(
        "Gagal mengambil data affiliate. Pesan: ${response?['message']}",
      );
    }

    try {
      try {
        final encodeValue = json.encode(response);
        log(encodeValue, name: endpoint);
      } catch (e) {}

      // Ambil bagian utama dari data response
      final responseData = response['data'];

      if (affiliateId != null) {
        // Jika mengambil data satu kontak berdasarkan ID
        final contactData = (responseData['data'] as List).isNotEmpty
            ? responseData['data'][0]
            : {};
        return {'data': contactData, 'count': contactData.isNotEmpty ? 1 : 0};
      } else {
        // Jika mengambil semua kontak
        final List<Map<String, dynamic>> affiliateList =
            List<Map<String, dynamic>>.from(responseData['data']);
        final int count = responseData['count'] ?? 0;

        return {'data': affiliateList, 'count': count};
      }
    } catch (e, stacktace) {
      debugPrint("stacktace : $stacktace");
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> calculateTask() async {
    final token = StorageService.getToken();

    final response = await apiRequest(
      method: 'GET',
      endpoint: '/crm/calculate_task?order=sort_number&order_by=asc',
      body: null,
      token: token,
      contentType: 'application/json',
    );

    return List<Map<String, dynamic>>.from(response?['data']['data']);
  }


  // ============================== WORKSPACE ============================== //
  static Future<List<Map<String, dynamic>>> workspaceFind({
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    final response = await apiRequest(
      method: 'GET',
      endpoint:
          '/workspace${params != null ? GeneralService.buildQueryParams(params) : ""}',
      body: null,
      token: token,
      contentType: 'application/json',
    );

    return List<Map<String, dynamic>>.from(response?['data']['data'] ?? []);
  }


  // ============================== NOTIFICATION ============================== //
  static Future<Map<String, dynamic>?> getNotifications(
    String token,
    String filter,
  ) async {
    String dateFilter = GeneralService.getDateFilter(filter);

    // Buat endpoint dengan filter created_at
    String endpoint = '/notifikasi?order=created_at&order_by=desc';
    if (dateFilter.isNotEmpty) {
      // endpoint += '&created_at=$dateFilter';
    }
    final response = await apiRequest(
      method: 'GET',
      endpoint: endpoint,
      body: null,
      token: token,
      contentType: 'application/json',
    );

    return response;
  }

  static Future<Map<String, dynamic>?> setNotificationsAsRead(
    String token,
    int id,
  ) async {
    final response = await apiRequest(
      method: 'PUT',
      endpoint: '/notifikasi/set-read/$id',
      body: null,
      token: token,
      contentType: 'application/json',
    );
    return response;
  }


  // ============================== BOARD ============================== //
  static Future<dynamic> handleBoard({
    required String method, // 'GET', 'POST', 'PUT', 'DELETE'
    required int workspaceId, // Tidak boleh null dan wajib diisi
    int? boardId, // Diperlukan untuk Update dan Delete
    Map<String, dynamic>? data, // Body data untuk Create atau Update
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    // Tentukan endpoint berdasarkan metode
    String endpoint;
    if (method == 'GET') {
      endpoint =
          '/board/$workspaceId?order=sort_number&order_by=asc${params != null ? '&${GeneralService.justBuildQuery(params)}' : ""}';
    } else if (method == 'POST') {
      endpoint = '/board'; // Endpoint untuk create board
    } else if (method == 'PUT' && boardId != null) {
      endpoint = '/board/$boardId'; // Endpoint untuk update board
    } else if (method == 'DELETE' && boardId != null) {
      endpoint = '/board/$boardId'; // Endpoint untuk delete board
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    // Panggil API sesuai metode
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      contentType: 'application/json',
    );

    // Validasi response
    if (response != null && response['success'] == true) {
      if (method == 'GET') {
        return List<Map<String, dynamic>>.from(response['data']['data'] ?? []);
      } else {
        return response['data']; // Return hasil operasi selain GET
      }
    } else {
      throw Exception('Operasi $method gagal pada endpoint $endpoint');
    }
  }


  // ============================== TASK ============================== //
  static Future<dynamic> handleTask({
    required String method, // 'GET', 'POST', 'PUT', 'DELETE'
    int? boardId, // Tidak boleh null dan wajib diisi
    int? taskId,
    Map<String, dynamic>? data,
    String? search,
    String? contentType,
    List<http.MultipartFile> listFile = const [],
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    // Tentukan endpoint berdasarkan metode
    String endpoint;
    if (method == 'GET') {
      endpoint =
          '/task/$boardId?order=sort_number&order_by=asc${params != null ? '&${GeneralService.justBuildQuery(params)}' : ""}';
      if (search != null && search.isNotEmpty) {
        endpoint =
            '/task?search=$search${params != null ? '&${GeneralService.justBuildQuery(params)}' : ""}';
      }
    } else if (method == 'POST') {
      endpoint = '/task'; // Endpoint untuk create board
    } else if (method == 'PUT' && taskId != null) {
      endpoint = '/task/$taskId'; // Endpoint untuk update board
    } else if (method == 'DELETE' && taskId != null) {
      endpoint = '/task/$taskId'; // Endpoint untuk delete board
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    // Panggil API sesuai metode
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      listFile: listFile,
      contentType: method == 'PUT' && listFile.isNotEmpty
          ? 'multipart/form-data'
          : contentType ?? 'application/json',
    );
    try {
      final encodeValue = json.encode(response);
      log(encodeValue, name: endpoint);
    } catch (e) {}

    // Validasi response
    if (response != null && response['success'] == true) {
      if (method == 'GET') {
        final currentData = response['data']['data'] ?? [];
        return List<Map<String, dynamic>>.from(currentData);
      } else {
        return response['data']; // Return hasil operasi selain GET
      }
    } else {
      throw Exception('Operasi $method gagal pada endpoint $endpoint');
    }
  }

  static Future<dynamic> handleTaskFile({
    required String method, // 'GET', 'POST', 'PUT', 'DELETE'
    required int taskId, // Tidak boleh null dan wajib diisi
    int? fileId,
    Map<String, dynamic>? data, // Body data untuk Create atau Update
    List<http.MultipartFile> listFile = const [],
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    // Tentukan endpoint berdasarkan metode
    String endpoint;
    if (method == 'GET') {
      endpoint =
          '/task/file/$taskId${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/task/file';
    } else if (method == 'PUT' && fileId != null) {
      endpoint = '/task/file/$fileId';
    } else if (method == 'DELETE' && fileId != null) {
      endpoint = '/task/file/$fileId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    // Panggil API sesuai metode
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      listFile: listFile,
      contentType: method == 'POST'
          ? 'multipart/form-data'
          : 'application/json',
    );
    try {
      final encodeValue = json.encode(response);
      log(encodeValue, name: endpoint);
    } catch (e) {}

    // Validasi response
    if (response != null && response['success'] == true) {
      if (method == 'GET') {
        final currentData = response['data']['data'] ?? [];
        return List<Map<String, dynamic>>.from(currentData);
      } else {
        return response['data']; // Return hasil operasi selain GET
      }
    } else {
      throw Exception('Operasi $method gagal pada endpoint $endpoint');
    }
  }

  static Future<dynamic> handleLabel({
    required String method, // 'GET', 'POST', 'PUT', 'DELETE'
    int? labelId,
    Map<String, dynamic>? data,
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    // Tentukan endpoint berdasarkan metode
    String endpoint;
    if (method == 'GET') {
      endpoint =
          '/task/label${labelId != null ? "/$labelId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/task/label'; // Endpoint untuk create board
    } else if (method == 'PUT' && labelId != null) {
      endpoint = '/task/label/$labelId'; // Endpoint untuk update board
    } else if (method == 'DELETE' && labelId != null) {
      endpoint = '/task/label/$labelId'; // Endpoint untuk delete board
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    // Panggil API sesuai metode
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      contentType: method == 'PUT' ? 'multipart/form-data' : 'application/json',
    );
    try {
      final encodeValue = json.encode(response);
      log(encodeValue, name: endpoint);
    } catch (e) {}

    // Validasi response
    if (response != null && response['success'] == true) {
      if (method == 'GET') {
        final currentData = response['data']['data'] ?? [];
        return List<Map<String, dynamic>>.from(currentData);
      } else {
        return response['data']; // Return hasil operasi selain GET
      }
    } else {
      throw Exception('Operasi $method gagal pada endpoint $endpoint');
    }
  }

  static Future<dynamic> handleComment({
    required String method,
    int? commentId,
    int? taskId,
    Map<String, dynamic>? data,
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();
    // Tentukan endpoint berdasarkan metode
    String endpoint;
    if (method == 'GET') {
      endpoint =
          '/task/comment${taskId != null ? "/$taskId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/task/comment';
    } else if (method == 'PUT' && commentId != null) {
      endpoint = '/task/comment/$commentId';
    } else if (method == 'DELETE' && commentId != null) {
      endpoint = '/task/comment/$commentId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    // Panggil API sesuai metode
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: {
        if (taskId != null) ...{"task_id": taskId},
        ...(data ?? {}),
      },
      token: token,
      contentType: method == 'PUT' ? 'multipart/form-data' : 'application/json',
    );
    try {
      final encodeValue = json.encode(response);
      log(encodeValue, name: endpoint);
    } catch (e) {}

    // Validasi response
    if (response != null && response['success'] == true) {
      if (method == 'GET') {
        final currentData = response['data']['data'] ?? [];
        return List<Map<String, dynamic>>.from(currentData);
      } else {
        return response['data']; // Return hasil operasi selain GET
      }
    } else {
      throw Exception('Operasi $method gagal pada endpoint $endpoint');
    }
  }

  static Future<dynamic> handleChecklist({
    required String method,
    int? checklistId,
    int? taskId,
    Map<String, dynamic>? data,
    Map<String, String>? params,
  }) async {
    final token = StorageService.getToken();

    // Tentukan endpoint berdasarkan metode
    String endpoint;
    if (method == 'GET') {
      endpoint =
          '/task/checklist${taskId != null ? "/$taskId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/task/checklist';
    } else if (method == 'PUT' && checklistId != null) {
      endpoint = '/task/checklist/$checklistId';
    } else if (method == 'DELETE' && checklistId != null) {
      endpoint = '/task/checklist/$checklistId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    // Panggil API sesuai metode
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: {
        if (taskId != null) ...{"task_id": taskId},
        ...(data ?? {}),
      },
      token: token,
      contentType: method == 'PUT' ? 'multipart/form-data' : 'application/json',
    );

    try {
      final encodeValue = json.encode(response);
      log(encodeValue, name: endpoint);
    } catch (e) {}

    // Validasi response
    if (response != null && response['success'] == true) {
      if (method == 'GET') {
        final currentData = response['data']['data'] ?? [];
        return List<Map<String, dynamic>>.from(currentData);
      } else {
        return response['data']; // Return hasil operasi selain GET
      }
    } else {
      throw Exception('Operasi $method gagal pada endpoint $endpoint');
    }
  }

  static Future<dynamic> handleDetailTask(int taskId) async {
    final token = StorageService.getToken();

    // Tentukan endpoint berdasarkan metode
    String endpoint = "/task/detail/$taskId";
    // Panggil API sesuai metode
    final response = await apiRequest(
      method: "GET",
      endpoint: endpoint,
      token: token,
    );
    try {
      final encodeValue = json.encode(response);
      log(encodeValue, name: endpoint);
    } catch (e) {}

    // Validasi response
    if (response != null && response['success'] == true) {
      return response['data']['data']; // Return hasil operasi selain GET
    } else {
      throw Exception('Operasi GET gagal pada endpoint $endpoint');
    }
  }

  static Future<dynamic> handleChecklistItem({
    required String method,
    int? checklistItemId,
    int? checklistId,
    Map<String, dynamic>? data,
  }) async {
    final token = StorageService.getToken();

    // Tentukan endpoint berdasarkan metode
    String endpoint;
    if (method == 'GET') {
      endpoint =
          '/task/checklist/item${checklistItemId != null ? "/$checklistItemId" : ""}';
    } else if (method == 'POST') {
      endpoint = '/task/checklist/item';
    } else if (method == 'PUT' && checklistItemId != null) {
      endpoint = '/task/checklist/item/$checklistItemId';
    } else if (method == 'PATCH' && checklistItemId != null) {
      endpoint = '/task/checklist/item/convert_to_task/$checklistItemId';
    } else if (method == 'DELETE' && checklistItemId != null) {
      endpoint = '/task/checklist/item/$checklistItemId';
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    // Panggil API sesuai metode
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: {
        if (checklistId != null) ...{"task_checklist_id": checklistId},
        ...(data ?? {}),
      },
      token: token,
    );

    try {
      final encodeValue = json.encode(response);
      log(encodeValue, name: endpoint);
    } catch (e) {}

    // Validasi response
    if (response != null && response['success'] == true) {
      if (method == 'GET') {
        final currentData = response['data']['data'] ?? [];
        return List<Map<String, dynamic>>.from(currentData);
      } else {
        return response['data']; // Return hasil operasi selain GET
      }
    } else {
      throw Exception('Operasi $method gagal pada endpoint $endpoint');
    }
  }


  // ============================== MASTER DATA (PROJECT) ============================== //
  static Future<dynamic> handleProject({
    required String method, // 'GET', 'POST', 'PUT', 'DELETE'
    int? projectId,
    Map<String, dynamic>? data,
    Map<String, String>? params,
    List<http.MultipartFile> listFile = const [],
  }) async {
    final token = StorageService.getToken();

    // Tentukan endpoint berdasarkan metode
    String endpoint;
    if (method == 'GET') {
      endpoint =
          '/project${projectId != null ? "/$projectId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/project'; // Endpoint untuk create project
    } else if (method == 'PUT' && projectId != null) {
      endpoint = '/project/$projectId'; // Endpoint untuk update project
    } else if (method == 'DELETE' && projectId != null) {
      endpoint = '/project/$projectId'; // Endpoint untuk delete project
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    // Panggil API sesuai metode
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      listFile: listFile,
      contentType: method == 'PUT' || method == 'POST'
          ? 'multipart/form-data'
          : 'application/json',
    );
    try {
      final encodeValue = json.encode(response);
      log(encodeValue, name: endpoint);
    } catch (e) {}

    // Validasi response
    if (method == 'GET') {
      if (projectId != null) {
        // Handle GET untuk satu project berdasarkan ID
        final projectData = response?['data']['data'] ?? {};
        return {'data': projectData, 'count': 1};
      } else {
        // Handle GET untuk semua project (list)
        final currentData = response?['data']['data'] ?? [];
        final count = response?['data']['count'] ?? 0;
        return {
          'data': List<Map<String, dynamic>>.from(currentData),
          'count': count,
        };
      }
    } else if (method == 'DELETE' || method == 'POST' || method == 'PUT') {
      // Untuk operasi selain GET (POST, PUT, DELETE), hanya periksa success dan code
      if (response != null &&
          response['success'] == true &&
          response['code'] == 200) {
        return response; // Kembalikan response jika sukses
      } else {
        debugPrint(
          'Operasi gagal: ${response?['message']}',
        ); // Debugging pesan error
        throw Exception(
          'Operasi $method gagal pada endpoint $endpoint: ${response?['message']}',
        );
      }
    } else {
      // Jika tidak ada response yang valid
      throw Exception('Operasi $method gagal pada endpoint $endpoint');
    }
  }

  static String getProjectUrl({int? projectId}) {
    return projectId != null
        ? '$baseUrl/project/$projectId'
        : '$baseUrl/project';
  }

  static Future<String?> getToken() async {
    final token = StorageService.getToken();

    if (token == null || token.isEmpty) {
      return null;
    }
    return token;
  }


  // ============================== MASTER DATA (DIVISION) ============================== //
  static Future<dynamic> handleDivision({
    required String method, // 'GET', 'POST', 'PUT', 'DELETE'
    int? divisiId,
    Map<String, dynamic>? data,
    Map<String, String>? params, // Body data untuk Create atau Update
  }) async {
    final token = StorageService.getToken();

    // Tentukan endpoint berdasarkan metode
    String endpoint;
    if (method == 'GET') {
      endpoint =
          '/divisi${divisiId != null ? "/$divisiId" : ""}${params != null ? GeneralService.buildQueryParams(params) : ""}';
    } else if (method == 'POST') {
      endpoint = '/divisi'; // Endpoint untuk create divisi
    } else if (method == 'PUT' && divisiId != null) {
      endpoint = '/divisi/$divisiId'; // Endpoint untuk update divisi
    } else if (method == 'DELETE' && divisiId != null) {
      endpoint = '/divisi/$divisiId'; // Endpoint untuk delete divisi
    } else {
      throw Exception('Parameter tidak lengkap untuk operasi $method');
    }

    // Panggil API sesuai metode
    final response = await apiRequest(
      method: method,
      endpoint: endpoint,
      body: data,
      token: token,
      contentType: method == 'PUT' ? 'multipart/form-data' : 'application/json',
    );
    try {
      final encodeValue = json.encode(response);
      log(encodeValue, name: endpoint);
    } catch (e) {}

    // Validasi response
    if (method == 'GET') {
      if (divisiId != null) {
        // Handle GET untuk satu divisi berdasarkan ID
        final divisionData = response?['data']['data'] ?? {};
        return {'data': divisionData, 'count': 1};
      } else {
        // Handle GET untuk semua divisi (list)
        final currentData = response?['data']['data'] ?? [];
        final count = response?['data']['count'] ?? 0;
        return {
          'data': List<Map<String, dynamic>>.from(currentData),
          'count': count,
        };
      }
    } else if (method == 'DELETE' || method == 'POST' || method == 'PUT') {
      // Untuk operasi selain GET (POST, PUT, DELETE), hanya periksa success dan code
      if (response != null &&
          response['success'] == true &&
          response['code'] == 200) {
        return response; // Kembalikan response jika sukses
      } else {
        debugPrint('Operasi gagal: ${response?['message']}');
        throw '${response?['data']['message']}';
      }
    } else {
      // Jika tidak ada response yang valid
      throw '${response?['data']['message']}';
    }
  }


  // ============================== MASTER DATA (ROLE) ============================== //
  static Future<Map<String, dynamic>?> getRoles() async {
    final token = StorageService.getToken();
    final response = await apiRequest(
      method: 'GET',
      endpoint: '/role',
      body: {},
      token: token,
      contentType: 'application/json',
    );

    if (response != null && response['success'] == true) {
      return response['data'];
    } else {
      return {'message': 'Failed to fetch data role', 'data': null};
    }
  }


  // ============================== EXPORT DATA ============================== //
  static Future<http.Response> apiRequestExportData({
    required String method,
    required String endpoint,
    Map<String, String>? params,
    String? token,
  }) async {
    // init
    http.Response response;
    final url = '$baseUrl$endpoint';
    Map<String, String> header = {};

    if (token != null) {
      header['Authorization'] = 'Bearer $token';
    }

    try {
      // function hit api
      Future<http.Response> hitAPI() async {
        switch (method.toUpperCase()) {
          case 'GET':
            return http.get(
              Uri.parse(
                '$url${params != null ? GeneralService.buildQueryParams(params) : ""}',
              ),
              headers: header,
            );
          default:
            throw Exception('Unsupported HTTP method: $method');
        }
      }

      // hit api
      response = await hitAPI();
      // cek if refresh token needed
      final isAuthEndpoint = [
        "/auth/login",
        "/auth/logout",
        "/auth/send-email/forgot-password",
        "/auth/verify-number",
        "/auth/register",
      ];
      if (response.statusCode == 401 && !isAuthEndpoint.contains(endpoint)) {
        final newToken = await _refreshToken(token);
        if (newToken != null) {
          header['Authorization'] = 'Bearer $newToken';
          response = await hitAPI();
        } else {
          await _handleExpiredSession();
          throw Exception("Session Expired");
        }
      } else if (response.statusCode == 422 && !isAuthEndpoint.contains(endpoint)) {
        await _handleExpiredSession();
        throw Exception("Session Expired");
      }

      return response;
    } catch (e, trace) {
      debugPrint("trace :>>> $trace");
      // return null;
      rethrow;
    }
  }

  static Future<http.Response> exportUsers() async {
    final token = StorageService.getToken();
    final response = await apiRequestExportData(
      method: 'GET',
      endpoint: '/user/export',
      params: {'format':'pdf'},
      token: token,
    );
    return response;
  }
}
