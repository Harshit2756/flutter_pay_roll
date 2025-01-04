
class LeaveRequestModel {
  final List<LeaveRequest> list;

  LeaveRequestModel({required this.list});

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      list: List<LeaveRequest>.from(json['list'].map((x) => LeaveRequest.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    'list': list.map((x) => x.toJson()).toList(),
  };
}

class LeaveRequest {
  final String date;
  final String remark;
  final String leaveType;
  final String status;
  final String? lastStatusDate;
  final String reqDate;
  final String? lastUserName;

  LeaveRequest({
    required this.date,
    required this.remark,
    required this.leaveType,
    required this.status,
    this.lastStatusDate,
    required this.reqDate,
    this.lastUserName,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      date: json['date'],
      remark: json['remark'],
      leaveType: json['leaveType'],
      status: json['status'],
      lastStatusDate: json['lastStatusDate'],
      reqDate: json['reqDate'],
      lastUserName: json['lastUserName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'remark': remark,
    'leaveType': leaveType,
    'status': status,
    'lastStatusDate': lastStatusDate,
    'reqDate': reqDate,
    'lastUserName': lastUserName,
  };
}