import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:pay_roll/model/history_model.dart";

import "../jsons/dummy_json.dart";
import "../shared/storage_helper.dart";

class AttendanceService {
  // get attendance history
  Future<HistoryResponse> fetchAttendanceHistory(
      String dateFrom, String dateTo) async {
    try {
      // Parse the date range using a more robust parsing approach
      DateTime startDate;
      DateTime endDate;

      try {
        // First try parsing in yyyy-MM-dd format
        startDate = DateTime.parse(dateFrom);
        endDate = DateTime.parse(dateTo);
      } catch (e) {
        // If that fails, try dd-MM-yyyy format
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        startDate = formatter.parse(dateFrom);
        endDate = formatter.parse(dateTo);
      }

      // Generate attendance data for the date range
      List<Map<String, dynamic>> attendanceData = [];

      for (DateTime date = startDate;
          date.isBefore(endDate.add(const Duration(days: 1)));
          date = date.add(const Duration(days: 1))) {
        // Generate status based on day of week
        String status;
        String? footer;

        // Determine status and footer based on day of week
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          status = "weekoff";
          footer = null;
        } else if (date.day % 15 == 0) {
          // Every 15th day is WFH
          status = "wfh";
          footer = null;
        } else if (date.day % 10 == 0) {
          // Every 10th day is halfday
          status = "halfday";
          footer =
              "${(6 + date.day % 12).toString().padLeft(2, '0')}h ${(30 + date.day % 30).toString().padLeft(2, '0')}m";
        } else {
          status = "present";
          footer = date.day % 3 == 0
              ? "${(7 + date.day % 4).toString().padLeft(2, '0')}h ${(45 + date.day % 15).toString().padLeft(2, '0')}m"
              : null;
        }

        // Ensure consistent date format in output
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        attendanceData.add(
            {"transDate": formattedDate, "footer": footer, "status": status});
      }

      // Count different status types
      int presentCount =
          attendanceData.where((a) => a["status"] == "present").length;
      int wfhCount = attendanceData.where((a) => a["status"] == "wfh").length;
      int weekoffCount =
          attendanceData.where((a) => a["status"] == "weekoff").length;
      int halfdayCount =
          attendanceData.where((a) => a["status"] == "halfday").length;

      final mockResponse = {
        "summary": {
          "attendance": attendanceData,
          "summary": [
            {"status": "leave", "count": 0},
            {"status": "absent", "count": 0},
            {"status": "present", "count": presentCount},
            {"status": "wfh", "count": wfhCount},
            {"status": "holiday", "count": 0},
            {"status": "weekoff", "count": weekoffCount},
            {"status": "halfday", "count": halfdayCount}
          ]
        }
      };

      await Future.delayed(const Duration(milliseconds: 500));
      return HistoryResponse.fromJson(mockResponse);
    } catch (e) {
      debugPrint('Error in fetchAttendanceHistory: $e');
      throw FormatException(
          'Invalid date format. Please use yyyy-MM-dd or dd-MM-yyyy format');
    }
  }

  Future<Map<String, dynamic>> getAttendanceStatus() async {
    try {
      // Mock response data instead of API call
      final Map<String, dynamic> mockResponse = lastEntry;
      await Future.delayed(const Duration(milliseconds: 500));
      return mockResponse;
    } catch (e) {
      debugPrint('Error occurred during attendance status check: $e');
      // Return a safe default response
      rethrow;
    }
  }

  Future<void> punchIn() async {
    try {
      await StorageHelper.setAttendanceStatus("IN");
    } catch (e) {
      debugPrint('Error in punchIn: $e');
      rethrow;
    }
  }

  Future<void> punchOut() async {
    try {
      await StorageHelper.setAttendanceStatus("OUT");
    } catch (e) {
      debugPrint('Error in punchOut: $e');
      rethrow;
    }
  }
}
