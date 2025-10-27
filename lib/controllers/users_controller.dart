import 'dart:io';
import 'package:flutter_cleancare/core/services/api_service.dart';
import 'package:flutter_cleancare/data/models/users_single_model.dart';
import 'package:flutter_cleancare/widgets/app_snackbar_raw.dart';
import 'package:get/get.dart';
import 'package:flutter_cleancare/data/models/users_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  var users = <Users>[].obs;
  var userSingle = Rxn<UserSingle>();
  var searchQuery = ''.obs;
  final sortOrder = 'A-Z'.obs;
  final filterRole = 'Cleaning Service'.obs;
  var selectedImageEdit = Rx<XFile?>(null);
  final profilC = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshUsers();
  }

  void searchUser(String query) {
    searchQuery.value = query;
    refreshUsers();
  }

  void sortUsers(String? sort) {
    sortOrder.value = sort!;
    refreshUsers();
  }

  void filterUsersByRole(String? role) {
    filterRole.value = role!;
    refreshUsers();
  }

  Future<void> refreshUsers() async {
    late Map<String, String> param = {
      'no_paging': 'yes',
      'order_by': 'name'
    };
    if (searchQuery.value!=''){
      param['search'] = searchQuery.value;
    }
    if (sortOrder.value=='A-Z'){
      param['order'] = 'name';
      param['order_by'] = 'asc';
    }else{
      param['order'] = 'name';
      param['order_by'] = 'desc';
    }
    if (filterRole.value=='Cleaning Service'){
      param['role_id'] = '2';
    }else{
      param['role_id'] = '1';
    }
    final response = await ApiService.handleUser(
      method: 'GET',
      params: param,
    );
    if (response != null && response['success'] == true) {
      final data = response['data'];
      final List<dynamic> userList = data['data'] ?? [];
      final usersData = userList.map((e) => Users.fromJson(e)).toList();
      users.value = usersData;
    } else {
      final errorData = response?['data'];
      final message = errorData?['message'] ?? 'Terjadi kesalahan tidak diketahui';
      AppSnackbarRaw.error(message);
    }
  }

  Future<void> exportUsers() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          AppSnackbarRaw.error('Izin penyimpanan ditolak.');
          return;
        }
      }

      final response = await ApiService.exportUsers();
      if (response.statusCode == 200) {
        String filename = 'users.pdf';
        final contentDisposition = response.headers['content-disposition'];
        if (contentDisposition != null) {
          final regex = RegExp(r'filename="?([^"]+)"?');
          final match = regex.firstMatch(contentDisposition);
          if (match != null) filename = match.group(1)!;
        }
        Directory? downloadsDir;
        if (Platform.isAndroid) {
          downloadsDir = Directory('/storage/emulated/0/Download');
        } else {
          downloadsDir = await getDownloadsDirectory();
        }

        if (downloadsDir == null || !downloadsDir.existsSync()) {
          AppSnackbarRaw.error('Folder Download tidak ditemukan.');
          return;
        }

        final filePath = '${downloadsDir.path}/$filename';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        AppSnackbarRaw.success('File tersimpan di folder Download: $filename');
      } else {
        AppSnackbarRaw.error('Gagal export (${response.statusCode})');
      }
    } catch (e) {
      AppSnackbarRaw.error('Terjadi kesalahan: $e');
    }
  }

  Future<String> create(String numberId, String name, int roleId) async {
    final Map<String, dynamic> data = {
      'number_id': numberId,
      'name': name,
      'role_id': roleId,
    };

    final response = await ApiService.handleUser(
      method: 'POST',
      data: data,
    );

    if (response != null && response['success'] == true) {
      return 'ok';
    } else {
      final errorMessage = response!['data']?['message'] ??
        response['message'] ??
        'Terjadi kesalahan saat registrasi.';
      return errorMessage;
    }
  }

  Future<void> getById(int id) async {
    final response = await ApiService.handleUser(
      method: 'GET',
      userId: id,
    );

    if (response != null && response['success'] == true) {
      final data = response['data']['data'];
      if (data != null) {
        final singleUser = UserSingle.fromJson(data);
        userSingle.value = singleUser;
      }else{
        userSingle.value = null;
      }
    }
  }

  Future<String> deleteById(int id) async {
    final response = await ApiService.handleUser(
      method: 'DELETE',
      userId: id,
    );
    if (response != null && response['success'] == true) {
      return 'ok';
    } else {
      final errorMessage = response!['data']?['message'] ??
        response['message'] ??
        'Terjadi kesalahan saat registrasi.';
      return errorMessage;
    }
  }

  void pickImageEdit() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImageEdit.value = image;
    }
  }

  void clearImageEdit() {
    selectedImageEdit.value = null;
    profilC.value = '';
  }

  Future<String> updateById(int id, Map<String, dynamic> data, XFile? profile, String contentType) async {
    final List<http.MultipartFile> files = [];
    if (profile != null) {
      final file = await http.MultipartFile.fromPath('profile', profile.path);
      files.add(file);
    }

    final response = await ApiService.handleUser(
      method: 'PUT',
      userId: id,
      data: data,
      listFile: files,
      contentType: contentType
    );

    if (response != null && response['success'] == true) {
      return 'ok';
    } else {
      final errorMessage = response!['data']?['message'] ??
        response['message'] ??
        'Terjadi kesalahan saat registrasi.';
      return errorMessage;
    }
  }
}
