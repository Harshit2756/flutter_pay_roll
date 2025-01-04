class AdjustDTOs {
  String? cycle;
  String? transDate;
  double? amount;
  String? remark;
  String? empAccName;
  String? transType;

  AdjustDTOs(
      {this.cycle,
      this.transDate,
      this.amount,
      this.remark,
      this.empAccName,
      this.transType});

  AdjustDTOs.fromJson(Map<String, dynamic> json) {
    cycle = json['cycle'];
    transDate = json['transDate'];
    amount = json['amount'];
    remark = json['remark'];
    empAccName = json['empAccName'];
    transType = json['transType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cycle'] = cycle;
    data['transDate'] = transDate;
    data['amount'] = amount;
    data['remark'] = remark;
    data['empAccName'] = empAccName;
    data['transType'] = transType;
    return data;
  }
}

class Bean {
  String? empName;
  String? cycle;
  double? ctc;
  String? ctcType;
  double? presentDays;
  double? absentDays;
  double? leaves;
  double? wfhDays;
  double? halfDays;
  double? weekOffs;
  double? paidLeaves;
  double? holidays;
  double? totalMarkDays;
  double? payableDays;
  double? perDaySalary;
  double? totalSalary;
  double? additions;
  double? deductions;
  double? netPayable;
  double? paid;
  double? balance;
  List<AdjustDTOs>? adjustDTOs;
  List<PaymentDTOs>? paymentDTOs;

  Bean(
      {this.empName,
      this.cycle,
      this.ctc,
      this.ctcType,
      this.presentDays,
      this.absentDays,
      this.leaves,
      this.wfhDays,
      this.halfDays,
      this.weekOffs,
      this.paidLeaves,
      this.holidays,
      this.totalMarkDays,
      this.payableDays,
      this.perDaySalary,
      this.totalSalary,
      this.additions,
      this.deductions,
      this.netPayable,
      this.paid,
      this.balance,
      this.adjustDTOs,
      this.paymentDTOs});

  Bean.fromJson(Map<String, dynamic> json) {
    empName = json['empName'];
    cycle = json['cycle'];
    ctc = json['ctc'];
    ctcType = json['ctcType'];
    presentDays = json['presentDays'];
    absentDays = json['absentDays'];
    leaves = json['leaves'];
    wfhDays = json['wfhDays'];
    halfDays = json['halfDays'];
    weekOffs = json['weekOffs'];
    paidLeaves = json['paidLeaves'];
    holidays = json['holidays'];
    totalMarkDays = json['totalMarkDays'];
    payableDays = json['payableDays'];
    perDaySalary = json['perDaySalary'];
    totalSalary = json['totalSalary'];
    additions = json['additions'];
    deductions = json['deductions'];
    netPayable = json['netPayable'];
    paid = json['paid'];
    balance = json['balance'];
    if (json['adjustDTOs'] != null) {
      adjustDTOs = <AdjustDTOs>[];
      json['adjustDTOs'].forEach((v) {
        adjustDTOs!.add(AdjustDTOs.fromJson(v));
      });
    }
    if (json['paymentDTOs'] != null) {
      paymentDTOs = <PaymentDTOs>[];
      json['paymentDTOs'].forEach((v) {
        paymentDTOs!.add(PaymentDTOs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empName'] = empName;
    data['cycle'] = cycle;
    data['ctc'] = ctc;
    data['ctcType'] = ctcType;
    data['presentDays'] = presentDays;
    data['absentDays'] = absentDays;
    data['leaves'] = leaves;
    data['wfhDays'] = wfhDays;
    data['halfDays'] = halfDays;
    data['weekOffs'] = weekOffs;
    data['paidLeaves'] = paidLeaves;
    data['holidays'] = holidays;
    data['totalMarkDays'] = totalMarkDays;
    data['payableDays'] = payableDays;
    data['perDaySalary'] = perDaySalary;
    data['totalSalary'] = totalSalary;
    data['additions'] = additions;
    data['deductions'] = deductions;
    data['netPayable'] = netPayable;
    data['paid'] = paid;
    data['balance'] = balance;
    if (adjustDTOs != null) {
      data['adjustDTOs'] = adjustDTOs!.map((v) => v.toJson()).toList();
    }
    if (paymentDTOs != null) {
      data['paymentDTOs'] = paymentDTOs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentDTOs {
  String? cycle;
  String? transDate;
  String? crAccName;
  double? amount;
  String? remark;
  String? drAccName;

  PaymentDTOs(
      {this.cycle,
      this.transDate,
      this.crAccName,
      this.amount,
      this.remark,
      this.drAccName});

  PaymentDTOs.fromJson(Map<String, dynamic> json) {
    cycle = json['cycle'];
    transDate = json['transDate'];
    crAccName = json['crAccName'];
    amount = json['amount'];
    remark = json['remark'];
    drAccName = json['drAccName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cycle'] = cycle;
    data['transDate'] = transDate;
    data['crAccName'] = crAccName;
    data['amount'] = amount;
    data['remark'] = remark;
    data['drAccName'] = drAccName;
    return data;
  }
}

class PaySlipModel {
  Bean? bean;

  PaySlipModel({this.bean});

  PaySlipModel.fromJson(Map<String, dynamic> json) {
    bean = json['bean'] != null ? Bean.fromJson(json['bean']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bean != null) {
      data['bean'] = bean!.toJson();
    }
    return data;
  }
}
