import 'package:flutter/material.dart';

class CharacterProvider with ChangeNotifier {
  String _statusFilter = ""; // Vacío = Sin filtro

  String get statusFilter => _statusFilter;

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners(); // Notifica a los widgets para reconstruirse
  }
}
