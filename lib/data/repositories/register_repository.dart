// lib/data/repositories/register_repository.dart
import 'package:flutter_cleancare/data/models/register_model.dart';

class RegisterRepository {
  // simulasi data employee yang sudah ada
  final List<Register> _registeredEmployees = [
    Register(userId: 'EMP001', name: 'John Doe', role: 'Staff'),
    Register(userId: 'EMP002', name: 'Jane Smith', role: 'Admin'),
    Register(userId: 'EMP003', name: 'Michael Lee', role: 'Staff'),
  ];

  // simulasi validasi ID
  Register? validateEmployeeId(String id) {
    try {
      return _registeredEmployees.firstWhere(
        (employee) => employee.userId == id,
      );
    } catch (e) {
      return null; // tidak ditemukan
    }
  }

  // simulasi proses register (belum nyimpan apa-apa)
  bool register(String email, String password) {
    // nanti di sini misalnya kita akan panggil API atau simpan ke database
    return true; // dummy sukses aja
  }
}
