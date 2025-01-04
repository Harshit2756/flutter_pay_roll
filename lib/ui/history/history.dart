import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay_roll/model/history_model.dart';
import 'package:pay_roll/services/attendance_service.dart';
import 'package:pay_roll/shared/contants.dart';
import 'package:pay_roll/shared/helpers.dart';
import 'package:pay_roll/shared/widgets/background.dart';
import 'package:pay_roll/ui/bottom_nav_bar.dart';

enum AttendanceStatus {
  present,
  wfh,
  holiday,
  weekoff,
  halfday,
  leave,
  absent,
  paidleave
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final GlobalKey<MonthViewState> _monthViewKey = GlobalKey<MonthViewState>();
  late EventController _calendarController;
  late Future<HistoryResponse> _attendanceHistoryFuture;

  DateTime _currentDate = DateTime.now();
  Map<DateTime, Attendance> _attendanceMap = {};

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: FutureBuilder<HistoryResponse>(
        future: _attendanceHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          _attendanceMap =
              _mapAttendanceData(snapshot.data!.summary.attendance);

          // Sort the attendance list by date
          final sortedAttendanceList = snapshot.data!.summary.attendance
            ..sort((a, b) => DateTime.parse(a.transDate)
                .compareTo(DateTime.parse(b.transDate)));

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildStatusSummary(snapshot.data!.summary.summary
                            .sublist(
                                0, snapshot.data!.summary.summary.length - 1)),
                        _buildCalendar(),
                        _buildAttendanceList(sortedAttendanceList),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _calendarController = EventController();
    // Set current date to previous month
    _currentDate = DateTime.now()
        .subtract(const Duration(days: 32)); // Ensure we're in previous month
    _attendanceHistoryFuture = _updateMonthViewDate(_currentDate);
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('Calendar'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false,
        ),
        icon: const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }

  Widget _buildAttendanceList(List<Attendance> attendanceList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attendanceList.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final attendance = attendanceList[index];
        return _buildCard(attendance);
      },
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 450,
      child: CalendarControllerProvider(
        controller: _calendarController,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: MonthView(
            key: _monthViewKey,
            hideDaysNotInMonth: true,
            initialMonth: _currentDate,
            pageViewPhysics: const NeverScrollableScrollPhysics(),
            controller: _calendarController,
            cellAspectRatio: 1,
            headerBuilder: (date) => _buildHeader(date),
            cellBuilder:
                (date, event, isToday, isInMonth, hideDaysNotInMonth) =>
                    _buildCellFromAttendance(date, isToday, isInMonth),
            onPageChange: (date, page) {
              setState(() {
                _currentDate = date;
                _attendanceHistoryFuture = _updateMonthViewDate(date);
              });
            },
          ),
        ),
      ),
    );
  }

  Card _buildCard(Attendance attendance) {
    final attendanceColor =
        Helper.getAttendanceCategoryCOlor(attendance.status);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.grey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: attendanceColor..withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('dd')
                        .format(DateTime.parse(attendance.transDate)),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    DateFormat('MMM')
                        .format(DateTime.parse(attendance.transDate)),
                    style: const TextStyle(
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attendance.status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    attendance.footer ?? 'Not Available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE')
                        .format(DateTime.parse(attendance.transDate)),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCellFromAttendance(DateTime date, bool isToday, bool isInMonth) {
    final attendance = _attendanceMap[date];
    final color = attendance != null
        ? Helper.getAttendanceCategoryCOlor(attendance.status)
            .withValues(alpha: 0.5)
        : isInMonth
            ? Colors.white
            : Colors.transparent;
    final footer = attendance?.footer ?? "";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: isToday ? Colors.white : color,
        border: Border.all(
          color: isInMonth
              ? (isToday ? Colors.black : Colors.black38)
              : Colors.transparent,
          width: isInMonth ? (isToday ? 2 : 1) : 0,
        ),
      ),
      child: Column(
        children: [
          Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isInMonth ? Colors.black87 : Colors.grey[500],
            ),
          ),
          if (footer.isNotEmpty)
            Text(
              footer,
              style: const TextStyle(color: Colors.black87, fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor..withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _monthViewKey.currentState?.previousPage(),
            icon: const Icon(Icons.chevron_left, color: Colors.white),
          ),
          Expanded(
            child: Text(
              '${DateFormat('MMMM').format(date)} ${DateFormat('yyyy').format(date)}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _monthViewKey.currentState?.nextPage(),
            icon: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCategory(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color..withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black..withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSummary(List<StatusSummary> statusSummaryList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (int i = 0; i < statusSummaryList.length; i += 3)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: statusSummaryList
                    .sublist(i, (i + 3).clamp(0, statusSummaryList.length))
                    .map((summary) => Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: _buildHistoryCategory(
                              summary.status,
                              summary.count.toString(),
                              Helper.getAttendanceCategoryCOlor(summary.status),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Map<DateTime, Attendance> _mapAttendanceData(
      List<Attendance> attendanceList) {
    return {
      for (var attendance in attendanceList)
        DateFormat('yyyy-MM-dd').parse(attendance.transDate): attendance,
    };
  }

  Future<HistoryResponse> _updateMonthViewDate(DateTime date) async {
    // Get first day of the month
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    // Get last day of the month
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    String dateFrom = Helper.formatDate(firstDayOfMonth);
    String dateTo = Helper.formatDate(lastDayOfMonth);
    return await AttendanceService().fetchAttendanceHistory(dateFrom, dateTo);
  }
}
