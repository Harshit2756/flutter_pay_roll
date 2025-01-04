import 'package:pay_roll/model/holidays_model.dart';
import 'package:pay_roll/model/leave_request_model.dart';
import 'package:pay_roll/model/pay_slip_model.dart';

class ProfileService {
  /// Get Cycles List
  Future<List<String>> getCyclesList() async {
    const mockResponse = {
      "list": ["Oct, 2024", "Nov, 2024", "Dec, 2024", "Jan, 2025"]
    };

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return mockResponse['list']!.cast<String>();
  }

  /// Get Holidays
  Future<HolidaysModel> getHolidaysList() async {
    const Map<String, dynamic> mockResponse = {
      "list": [
        {
          "id": 1,
          "date": "2025-01-26",
          "title": "Republic Day",
          "remark": "National Holiday"
        },
        {
          "id": 2,
          "date": "2025-02-19",
          "title": "Shivjayanti",
          "remark": "This leave will compensate by other day"
        },
        {
          "id": 3,
          "date": "2025-03-14",
          "title": "Holi",
          "remark": "National Holiday"
        },
        {
          "id": 4,
          "date": "2025-03-30",
          "title": "Gudi Padwa",
          "remark": "National Holiday"
        },
        {
          "id": 5,
          "date": "2025-05-01",
          "title": "Maharashtra Day",
          "remark": "National Holiday"
        },
        {
          "id": 6,
          "date": "2025-08-15",
          "title": "Independence Day",
          "remark": "National Holiday"
        },
        {
          "id": 7,
          "date": "2025-08-27",
          "title": "Ganesh Festival (First Day)",
          "remark": "National Holiday"
        },
        {
          "id": 8,
          "date": "2025-10-02",
          "title": "Dasra & M. Gandhi Jayanti",
          "remark": "National Holiday"
        },
        {
          "id": 9,
          "date": "2025-10-21",
          "title": "Laxmi Pooja",
          "remark": "National Holiday"
        },
        {
          "id": 10,
          "date": "2025-10-22",
          "title": "Balipratipada",
          "remark": "National Holiday"
        },
        {
          "id": 11,
          "date": "2025-10-23",
          "title": "Bhaubij",
          "remark": "National Holiday"
        }
      ]
    };

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return HolidaysModel.fromJson(mockResponse);
  }

  /// get leave request list
  Future<LeaveRequestModel> getLeaveRequestList() async {
    const Map<String, dynamic> mockResponse = {
      "list": [
        {
          "date": "2024-12-16",
          "remark": "family trip ",
          "leaveType": "casual leave",
          "status": "rejected",
          "lastStatusDate": "2024-12-03 00:00:00",
          "reqDate": "2024-12-02",
          "lastUserName": "billing@scube.com"
        },
        {
          "date": "2024-12-17",
          "remark": "family trip",
          "leaveType": "casual leave",
          "status": "approved",
          "lastStatusDate": "2024-12-03 00:00:00",
          "reqDate": "2024-12-02",
          "lastUserName": "billing@scube.com"
        },
        {
          "date": "2024-12-23",
          "remark": "marriage function ",
          "leaveType": "casual leave",
          "status": "approved",
          "lastStatusDate": "2024-12-25 00:00:00",
          "reqDate": "2024-12-23",
          "lastUserName": "billing@scube.com"
        },
        {
          "date": "2025-01-01",
          "remark": "Test",
          "leaveType": "wfh",
          "status": "pending",
          "lastStatusDate": null,
          "reqDate": "2024-12-31",
          "lastUserName": null
        }
      ]
    };

    return LeaveRequestModel.fromJson(mockResponse);
  }

  /// Get Pay Slip
  Future<PaySlipModel> getPaySlip({required String cycle}) async {
    const mockResponse = {
      "bean": {
        "empName": "Marketing - John Deo",
        "cycle": "Oct, 2024",
        "ctc": 17000.0,
        "ctcType": "Monthly",
        "presentDays": 20.0,
        "absentDays": 0.0,
        "leaves": 0.0,
        "wfhDays": 5.0,
        "halfDays": 0.0,
        "weekOffs": 4.0,
        "paidLeaves": 0.0,
        "holidays": 2.0,
        "totalMarkDays": 33.0,
        "payableDays": 31.0,
        "perDaySalary": 548.3871,
        "totalSalary": 17000.0,
        "additions": 2470.0,
        "deductions": 0.0,
        "netPayable": 19470.0,
        "paid": 3000.0,
        "balance": 16470.0,
        "adjustDTOs": [
          {
            "cycle": "Oct, 2024",
            "transDate": "2024-10-31",
            "amount": 1150.0,
            "remark": "",
            "empAccName": "Marketing -John Deo",
            "transType": "ADD"
          },
          {
            "cycle": "Oct, 2024",
            "transDate": "2024-10-31",
            "amount": 1320.0,
            "remark": "",
            "empAccName": "Marketing -John Deo",
            "transType": "ADD"
          }
        ],
        "paymentDTOs": [
          {
            "cycle": "Oct, 2024",
            "transDate": "2024-10-25",
            "crAccName": "Yes Bank Ltd 345 ",
            "amount": 3000.0,
            "remark": "advance",
            "drAccName": "Marketing - Priyanka Kunjir"
          }
        ]
      }
    };

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return PaySlipModel.fromJson(mockResponse);
  }

  /// Submit leave
  Future<void> submitLeaveRequest(
      {required String leaveType,
      required String fromDate,
      required String toDate,
      required String remarks,
      required bool isSingleLeave}) async {
    // Mock successful submission
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    return;
  }
}
