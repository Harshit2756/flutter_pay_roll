import 'package:flutter/material.dart';
import 'package:pay_roll/model/pay_slip_model.dart';
import 'package:pay_roll/services/profile_service.dart';
import 'package:pay_roll/shared/contants.dart';

class PaySlipsPage extends StatefulWidget {
  const PaySlipsPage({super.key});

  @override
  State<PaySlipsPage> createState() => _PaySlipsPageState();
}

class _PaySlipsPageState extends State<PaySlipsPage> {
  String? selectedCycle;
  final ProfileService _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pay Slip'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: _fetchCycles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDropdownContainer(snapshot.data!),
                      const SizedBox(height: 20),
                      _buildPaySlipContent(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedCycle = null;
  }

  Widget _buildAttendanceTable(Bean paySlip) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey..withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(10, 10),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 20,
            offset: Offset(-10, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        child: Table(
          border: TableBorder.all(
            color: primaryColor,
            width: 1,
          ),
          children: [
            _buildTableHeader('Attendance Summary'),
            _buildTableRow(
              label: 'Present',
              value: paySlip.presentDays!,
            ),
            _buildTableRow(
                label: 'Absent',
                value: paySlip.absentDays!,
                backgroundColor: Colors.grey[200]!),
            _buildTableRow(
              label: 'Leaves',
              value: paySlip.leaves!,
            ),
            _buildTableRow(
                label: 'WFH',
                value: paySlip.wfhDays!,
                backgroundColor: Colors.grey[200]!),
            _buildTableRow(label: 'Holidays', value: paySlip.holidays!),
            _buildTableRow(
                label: 'Week Off',
                value: paySlip.weekOffs!,
                backgroundColor: Colors.grey[200]!),
            _buildTableRow(
              label: 'Half Day',
              value: paySlip.halfDays!,
            ),
            _buildTableRow(
                label: 'Paid Leaves',
                value: paySlip.paidLeaves!,
                backgroundColor: Colors.grey[200]!),
            _buildTableRow(
              label: 'Total Days',
              value: paySlip.totalMarkDays!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownContainer(List<String> cycles) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey..withValues(alpha: 0.4),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: selectedCycle,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Cycle is required';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Select Cycle',
            labelStyle: const TextStyle(
              color: textSecondaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
          ),
          hint: const Text('Select cycle'),
          items: cycles.map((String cycle) {
            return DropdownMenuItem<String>(
              value: cycle,
              child: Text(cycle),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCycle = value;
            });
          },
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildDtoTable(Bean paySlip) {
    debugPrint("adjustDTOs: ${paySlip.adjustDTOs?.length}");
    return paySlip.adjustDTOs?.isEmpty == true
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey..withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(10, 10),
                ),
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: Offset(-10, -10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Table(
                border: TableBorder.all(
                  color: primaryColor,
                  width: 1,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                },
                children: [
                  _buildTableHeader(
                    "Additions / Deductions Amount",
                    secondLabel: "Remarks",
                    noOfColumns: 2,
                  ),
                  if (paySlip.adjustDTOs != null)
                    ...paySlip.adjustDTOs!.map(
                      (adjustDTO) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(adjustDTO.transType ?? " "),
                                  Text(
                                      "₹ ${adjustDTO.amount!.toStringAsFixed(2)}"),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(adjustDTO.remark ?? ""),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          );
  }

  Widget _buildPayDetailsTable(Bean paySlip) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey..withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(10, 10),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 20,
            offset: Offset(-10, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        child: Table(
          border: TableBorder.all(
            color: primaryColor,
            width: 1,
          ),
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
          },
          children: [
            _buildTableHeader("Category", secondLabel: "Value", noOfColumns: 2),
            _buildTableRow(
              label: 'Payable Days',
              amount: paySlip.payableDays!.toStringAsFixed(0),
              noOfColumns: 2,
            ),
            _buildTableRow(
              label: 'Per Day Salary',
              amount: "₹ ${paySlip.perDaySalary!.toStringAsFixed(2)}",
              noOfColumns: 2,
            ),
            _buildTableRow(
              label: 'Total Salary',
              amount: "₹ ${paySlip.totalSalary!.toStringAsFixed(2)}",
              noOfColumns: 2,
            ),
            _buildTableRow(
              label: 'Additions',
              amount: "₹ ${paySlip.additions!.toStringAsFixed(2)}",
              noOfColumns: 2,
            ),
            _buildTableRow(
              label: 'Deductions',
              amount: "₹ ${paySlip.deductions!.toStringAsFixed(2)}",
              noOfColumns: 2,
            ),
            _buildTableRow(
              label: 'Net Payable',
              amount: "₹ ${paySlip.netPayable!.toStringAsFixed(2)}",
              noOfColumns: 2,
            ),
            _buildTableRow(
              label: 'Paid',
              amount: "₹ ${paySlip.paid!.toStringAsFixed(2)}",
              noOfColumns: 2,
            ),
            _buildTableRow(
              label: 'Balance',
              amount: "₹ ${paySlip.balance!.toStringAsFixed(2)}",
              noOfColumns: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTable(Bean paySlip) {
    debugPrint("paymentDTOs: ${paySlip.paymentDTOs}");
    return paySlip.paymentDTOs?.isEmpty == true
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey..withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(10, 10),
                ),
                const BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  offset: Offset(-10, -10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Table(
                border: TableBorder.all(
                  color: primaryColor,
                  width: 1,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  _buildTableHeader(
                    "Date",
                    secondLabel: "Paid Amount",
                    thirdLabel: "Paid From Account",
                    noOfColumns: 3,
                  ),
                  if (paySlip.paymentDTOs != null)
                    ...paySlip.paymentDTOs!.map(
                      (paymentDTOs) {
                        return _buildTableRow(
                          label: paymentDTOs.transDate ?? " ",
                          amount: "₹ ${paymentDTOs.amount!.toStringAsFixed(2)}",
                          thirdValue: paymentDTOs.crAccName,
                          noOfColumns: 3,
                        );
                      },
                    ),
                ],
              ),
            ),
          );
  }

  Widget _buildPaySlipContent() {
    if (selectedCycle == null) {
      return const Center(
        child: Text(
          "No Month Selected",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
    }

    return FutureBuilder<PaySlipModel>(
      future: _fetchPaySlip(selectedCycle!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }
        final paySlipModel = snapshot.data!;
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor..withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey..withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(10, 10),
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 20,
                    offset: Offset(-10, -10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name : ${paySlipModel.bean!.empName!.split("- ").last} (${paySlipModel.bean!.empName!.split(" -").first})",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Salary (CTC): ${paySlipModel.bean!.ctc!.toStringAsFixed(0)} / ${paySlipModel.bean!.ctcType} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildAttendanceTable(paySlipModel.bean!),
            const SizedBox(height: 20),
            _buildDtoTable(paySlipModel.bean!),
            const SizedBox(height: 20),
            _buildPayDetailsTable(paySlipModel.bean!),
            const SizedBox(height: 20),
            _buildPaymentTable(paySlipModel.bean!),
          ],
        );
      },
    );
  }

  TableRow _buildTableHeader(String label,
      {int noOfColumns = 1, String secondLabel = "", String thirdLabel = ""}) {
    return TableRow(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor..withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (noOfColumns == 2 || noOfColumns == 3)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              secondLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        if (noOfColumns == 3)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              thirdLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  TableRow _buildTableRow({
    Color backgroundColor = Colors.white,
    required String label,
    num? value,
    int noOfColumns = 1,
    String? amount,
    String? thirdValue,
    bool isAdd = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey[600]!,
            width: 1,
          ),
        ),
      ),
      children: !isAdd
          ? noOfColumns == 1
              ? [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          value?.toStringAsFixed(0) ?? " ",
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(label,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                        textAlign: noOfColumns == 3
                            ? TextAlign.center
                            : TextAlign.left),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      amount ?? " ",
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                      textAlign:
                          noOfColumns == 3 ? TextAlign.center : TextAlign.right,
                    ),
                  ),
                  if (noOfColumns == 3)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        thirdValue ?? " ",
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ]
          : [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      amount ?? " ",
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  thirdValue ?? " ",
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
    );
  }

  Future<List<String>> _fetchCycles() async {
    final cycles = await _profileService.getCyclesList();
    return cycles;
  }

  Future<PaySlipModel> _fetchPaySlip(String cycle) async {
    final paySlipModel = await _profileService.getPaySlip(cycle: cycle);
    return paySlipModel;
  }
}
