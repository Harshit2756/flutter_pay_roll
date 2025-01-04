import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay_roll/model/leave_request_model.dart';
import 'package:pay_roll/services/profile_service.dart';
import 'package:pay_roll/shared/contants.dart';
import 'package:pay_roll/shared/helpers.dart';
import 'package:pay_roll/shared/widgets/background.dart';
import 'package:pay_roll/shared/widgets/button.dart';
import 'package:pay_roll/shared/widgets/text_form_field.dart';

class LeaveRequest extends StatefulWidget {
  final int initialTabIndex;
  const LeaveRequest({super.key, this.initialTabIndex = 0});

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest>
    with SingleTickerProviderStateMixin {
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedLeaveType;
  bool _isLoading = false;
  final String _selectedStatus = 'single';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  final List<String> _leaveTypes = [
    'Sick Leave',
    'Casual Leave',
    'Paid Leave',
    'Half Day',
    'WFH',
    'Week Off',
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Leave Management'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'REQUEST'),
              Tab(text: 'HISTORY'),
            ],
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: primaryColor,
                  width: 6.0,
                ),
              ),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildRequestTab(),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    _reasonController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
  }

  Widget _buildHistoryTab() {
    return FutureBuilder<LeaveRequestModel>(
      future: _getLeaveRequestList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (!snapshot.hasData || snapshot.data!.list.isEmpty) {
          return const Center(child: Text('No leave request history'));
        }
        final leaveRequestList = snapshot.data!;
        return ListView.builder(
          itemCount: leaveRequestList.list.length,
          itemBuilder: (context, index) {
            final leaveRequest = leaveRequestList.list[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey..withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          leaveRequest.leaveType.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Helper.getLeaveRequestStatusColor(
                                leaveRequest.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            leaveRequest.status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Date of Leave: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: _formatDate(leaveRequest.date),
                            style: const TextStyle(
                              fontSize: 16,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Reason: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          TextSpan(
                            text: leaveRequest.remark,
                            style: const TextStyle(
                              fontSize: 16,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Requested on: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text: _formatDate(leaveRequest.reqDate),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (leaveRequest.status != 'pending') ...[
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${leaveRequest.status.substring(0, 1).toUpperCase()}${leaveRequest.status.substring(1)} on: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: _formatDate(leaveRequest.lastStatusDate!),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${leaveRequest.status.substring(0, 1).toUpperCase()}${leaveRequest.status.substring(1)} by: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: leaveRequest.lastUserName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRequestTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Leave Type Dropdown
                Container(
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
                      value: _selectedLeaveType,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Leave type is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Leave Type',
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
                          borderSide:
                              const BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      hint: const Text('Select leave type'),
                      items: _leaveTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toLowerCase(),
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLeaveType = value;
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
                ),
                const SizedBox(height: 16),

                // Date Range Fields
                TextFormFieldWidget(
                  hintText: !_isSingleLeave() ? 'From Date' : 'Select Date',
                  suffixIcon: const Icon(Icons.calendar_today),
                  controller: _fromDateController,
                  keyboardType: TextInputType.none,
                  readOnly: true,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      _fromDateController.text =
                          DateFormat('yyyy-MM-dd').format(date).toString();
                    }
                  },
                ),
                if (!_isSingleLeave()) ...[
                  const SizedBox(height: 16),
                  TextFormFieldWidget(
                    hintText: 'To Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                    controller: _toDateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () async {
                      if (_fromDateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select From date first'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      final fromDate = DateTime.parse(_fromDateController.text);
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: fromDate,
                        firstDate: fromDate,
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        _toDateController.text =
                            DateFormat('yyyy-MM-dd').format(date).toString();
                        _durationController.text =
                            (date.difference(fromDate).inDays + 1).toString();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Duration Field
                  TextFormFieldWidget(
                    readOnly: true,
                    enabled: false,
                    hintText: 'Duration in Days',
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Duration is required';
                      }
                      if (_fromDateController.text.isNotEmpty &&
                          _toDateController.text.isNotEmpty) {
                        final fromDate =
                            DateTime.parse(_fromDateController.text);
                        final toDate = DateTime.parse(_toDateController.text);
                        final duration = toDate.difference(fromDate).inDays + 1;
                        if (duration.toString() != value) {
                          return 'Duration must match the selected date range ($duration days)';
                        }
                      } else {
                        return 'Please select both From and To dates';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 16),
                // Reason Field
                TextFormFieldWidget(
                  hintText: 'Reason for Leave',
                  controller: _reasonController,
                  keyboardType: TextInputType.multiline,
                  isRequired: true,
                ),
                const SizedBox(height: 24),

                // Submit Button
                ButtonWidget(
                  isLoading: _isLoading,
                  text: 'Submit Request',
                  onPressed: _submitLeaveRequest,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(date));
  }

  Future<LeaveRequestModel> _getLeaveRequestList() async {
    final leaveRequestList = await ProfileService().getLeaveRequestList();
    debugPrint('leave request list is $leaveRequestList');
    return leaveRequestList;
  }

  bool _isSingleLeave() {
    return _selectedStatus == 'single';
  }

  // Submit Request
  void _submitLeaveRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await ProfileService().submitLeaveRequest(
        leaveType: _selectedLeaveType!,
        fromDate: _fromDateController.text,
        toDate: _isSingleLeave()
            ? _fromDateController.text
            : _toDateController.text,
        remarks: _reasonController.text,
        isSingleLeave: _isSingleLeave(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request submitted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
