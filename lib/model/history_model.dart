class HistoryResponse {
  final Summary summary;

  HistoryResponse({required this.summary});

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      summary: Summary.fromJson(json['summary']),
    );
  }
}

class Summary {
  final List<Attendance> attendance;
  final List<StatusSummary> summary;

  Summary({required this.attendance, required this.summary});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      attendance: (json['attendance'] as List)
          .map((e) => Attendance.fromJson(e))
          .toList(),
      summary: (json['summary'] as List)
          .map((e) => StatusSummary.fromJson(e))
          .toList(),
    );
  }
}

class Attendance {
  final String transDate;
  final String? footer;
  final String status;

  Attendance({
    required this.transDate,
    this.footer,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      transDate: json['transDate'],
      footer: json['footer'],
      status: json['status'],
    );
  }
}

class StatusSummary {
  final String status;
  final int count;

  StatusSummary({required this.status, required this.count});

  factory StatusSummary.fromJson(Map<String, dynamic> json) {
    return StatusSummary(
      status: json['status'],
      count: json['count'],
    );
  }
}
