class Holiday {
  final int id;
  final String date;
  final String title;
  final String remark;

  Holiday({
    required this.id,
    required this.date,
    required this.title,
    required this.remark,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      id: json['id'],
      date: json['date'],
      title: json['title'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'remark': remark,
    };
  }
}

class HolidaysModel {
  final List<Holiday> list;

  HolidaysModel({required this.list});

  factory HolidaysModel.fromJson(Map<String, dynamic> json) {
    return HolidaysModel(
      list:
          (json['list'] as List).map((item) => Holiday.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': list.map((holiday) => holiday.toJson()).toList(),
    };
  }
}
