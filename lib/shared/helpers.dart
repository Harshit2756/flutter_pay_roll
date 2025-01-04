import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static Color getAttendanceCategoryCOlor(String status) {
    switch (status.toLowerCase()) {
      case 'leave':
        return Colors.grey;
      case 'absent':
        return Colors.red;
      case 'present':
        return Colors.green;
      case 'wfh':
        return Colors.blue;
      case 'holiday':
        return Colors.yellow;
      case 'weekoff':
        return Colors.orange;
      case 'halfday':
        return Colors.purple;
      default:
        return Colors.white;
    }
  }

  static Color getLeaveRequestStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'rejected':
        return Colors.red;
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
