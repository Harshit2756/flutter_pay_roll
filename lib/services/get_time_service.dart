import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetTimeService {
  static final GetTimeService _instance = GetTimeService._();

  final String _apiUrl =
      'https://timeapi.io/api/time/current/zone?timeZone=Asia%2FKolkata';

  // store the response of the api call
  Map<String, dynamic> _currentTime = {};

  factory GetTimeService() {
    return _instance;
  }
  GetTimeService._() {
    // Initialize _currentTime in the constructor
    _initializeCurrentTime();
  }

  //  convert time to 12 hour format
  Future<String?> convertTo12HourFormat(
      String? time, bool isCurrentTime) async {
    String? timeString = isCurrentTime ? _currentTime['time'] : time;

    if (timeString == null) {
      return null;
    }
    // Split the time string into hours and minutes
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    String minutes = parts[1];

    // Convert 24-hour format to 12-hour format
    String period = hours >= 12 ? 'PM' : 'AM';
    hours = hours > 12 ? hours - 12 : hours;
    hours = hours == 0 ? 12 : hours;

    // Format the time string
    String formattedTime = '$hours:$minutes $period';
    return formattedTime;
  }

  DateTime convertUnixTimeToDateTime(String unixTimeString) {
    int unixTime = int.parse(unixTimeString);
    return DateTime.fromMillisecondsSinceEpoch(unixTime, isUtc: true);
  }

  DateTime getCurrentDate() {
    return DateTime.parse(_currentTime['dateTime']);
  }

  // Response model
  // {
  //   "year": 2024,
  //   "month": 11,
  //   "day": 14,
  //   "hour": 20,
  //   "minute": 47,
  //   "seconds": 53,
  //   "milliSeconds": 529,
  //   "dateTime": "2024-11-14T20:47:53.529872",
  //   "date": "11/14/2024",
  //   "time": "20:47",
  //   "timeZone": "Asia/Kolkata",
  //   "dayOfWeek": "Thursday",
  //   "dstActive": false
  // }

  String getCurrentDateString() {
    String date = _currentTime['date'];
    String formattedDate = date.replaceAll('/', '-');
    return formattedDate;
  }

  Future<DateTime> getCurrentDateTimeUTC() async {
    Map<String, dynamic> currentTime = await getCurrentTimeModel();
    return DateTime.parse(currentTime['dateTime']);
  }

  Future<String> getCurrentDateTimeUTCString() async {
    Map<String, dynamic> currentTime = await getCurrentTimeModel();
    return currentTime['dateTime'];
  }

  Future<String> getCurrentTime() async {
    Map<String, dynamic> currentTime = await getCurrentTimeModel();
    return currentTime['time'];
  }

  Future<Map<String, dynamic>> getCurrentTimeModel() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _currentTime = body;
        debugPrint('getCurrentTimeModel: $body');
        return body;
      } else {
        debugPrint('Failed to get time from API: ${response.statusCode}');
        throw Exception('Failed to get time from API');
      }
    } catch (e) {
      // Fallback to device time if API fails
      final now = DateTime.now();
      _currentTime = {
        'year': now.year,
        'month': now.month,
        'day': now.day,
        'hour': now.hour,
        'minute': now.minute,
        'seconds': now.second,
        'milliSeconds': now.millisecond,
        'dateTime': now.toIso8601String(),
        'date': '${now.month}/${now.day}/${now.year}',
        'time': '${now.hour}:${now.minute}',
        'timeZone': 'Local',
        'dayOfWeek': _getDayOfWeek(now.weekday),
        'dstActive': now.isUtc,
      };
      return _currentTime;
    }
  }

  Future<String> getUnixTimeString() async {
    Map<String, dynamic> currentTime = await getCurrentTimeModel();
    DateTime dateTime = DateTime.parse(currentTime['dateTime']);
    return (dateTime.millisecondsSinceEpoch).toString();
  }

  String _getDayOfWeek(int day) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[day - 1];
  }

  Future<void> _initializeCurrentTime() async {
    _currentTime = await getCurrentTimeModel();
  }
}
