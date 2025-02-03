import 'package:flutter/material.dart';

class CharacterProvider with ChangeNotifier {
  String _statusFilter = ""; 

  String get statusFilter => _statusFilter;

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners(); 
  }
}