import 'dart:async';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pay_roll/services/attendance_service.dart';
import 'package:pay_roll/services/get_time_service.dart';
import 'package:pay_roll/shared/loadings.dart';
import 'package:pay_roll/shared/storage_helper.dart';
import 'package:pay_roll/shared/widgets/background.dart';
import 'package:pay_roll/shared/widgets/text_form_field.dart';
import 'package:pay_roll/ui/attendance/camera_uid.dart';
import 'package:pay_roll/ui/auth/login.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../jsons/dummy_json.dart';
import '../../shared/contants.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class TimerProvider extends ChangeNotifier {
  String _currentTime = DateFormat('hh:mm a')
      .format(DateTime.now()); // Initialize with current time
  Timer? _timer;

  String get currentTime => _currentTime;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    // Update immediately and then start periodic updates
    _currentTime = DateFormat('hh:mm a').format(DateTime.now());
    notifyListeners();

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _currentTime = DateFormat('hh:mm a').format(DateTime.now());
      notifyListeners();
    });
  }
}

class _AttendancePageState extends State<AttendancePage> {
  late Future<Map<String, dynamic>> _userDataFuture;
  final TextEditingController _remarkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<SlideActionState> _slideActionKey = GlobalKey();

  bool isLoading = false;
  String _formattedDate = DateFormat('MMM dd, yyyy - EEEE')
      .format(DateTime.now()); // Initialize with current date

  @override
  Widget build(BuildContext context) {
    // debugPrint('isLoading is $isLoading');
    return BackgroundContainer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              isLoading) {
            return const Center(child: LoadingWidget());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final userData = snapshot.data!;
          final String employeeName =
              userData['username'] ?? 'Marketing - John Doe';
          final bool isPunchedOut = userData['isOut'] ?? false;
          final int employeeId = userData['empId'] ?? 2756;
          final String? entryTime = userData['entry_time'];
          final String? exitTime = userData['exit_time'];
          final String? transDate = userData['transDate'];
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                children: [
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Icon(Icons.person, color: textColor),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeName.split('- ').last,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "${employeeName.split('- ').first} - $employeeId",
                        style: const TextStyle(
                          fontSize: 14,
                          color: textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton.icon(
                  onPressed: _handleLogout,
                  icon:
                      const Icon(Icons.power_settings_new, color: primaryColor),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Consumer<TimerProvider>(
                      builder: (context, timerProvider, child) {
                        return Text(
                          timerProvider.currentTime,
                          style:
                              const TextStyle(color: textColor, fontSize: 48),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formattedDate,
                      style: const TextStyle(color: textColor, fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(flex: 2),
                    _buildAttendanceButton(
                      isPunchedOut: isPunchedOut,
                      onPunchIn: () =>
                          _openCameraUI(context, true, employeeId.toString()),
                      onPunchOut: () => _openBottomsheet(context, transDate),
                    ),
                    const Spacer(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTimeInfo(entryTime, ' In Time', punchInImage),
                        _buildTimeInfo(exitTime, ' Out Time', punchOutImage),
                      ],
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String> getFormattedDate() async {
    /// this return a string in dd-MM-yyyy format
    final DateTime now = GetTimeService().getCurrentDate();
    final formattedDate = DateFormat('MMM dd, yyyy - EEEE').format(now);
    return formattedDate;
  }

  Future<String> getFormattedTime() async {
    final DateTime now = await GetTimeService().getCurrentDateTimeUTC();
    final formattedTime = DateFormat('hh:mm a').format(now);
    return formattedTime;
  }

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
    // Start timer immediately after widget initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimerProvider>(context, listen: false).startTimer();
    });
  }

  Widget _buildAttendanceButton({
    required bool isPunchedOut,
    required VoidCallback onPunchIn,
    required VoidCallback onPunchOut,
  }) {
    return Neumorphic(
      style: const NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        depth: -10,
      ),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFE2E6EA),
          border: Border.all(color: Colors.white, width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: NeumorphicButton(
          style: const NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            shape: NeumorphicShape.convex,
            intensity: 0.5,
            color: Colors.white,
          ),
          onPressed: isPunchedOut ? onPunchOut : onPunchIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                punchImage,
                width: 64,
                height: 64,
                color: isPunchedOut ? Colors.red : Colors.green,
              ),
              const SizedBox(height: 8),
              Text(
                isPunchedOut ? 'PUNCH OUT' : 'PUNCH IN',
                style: const TextStyle(fontSize: 18, color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String? time, String label, String image) {
    return Column(
      children: [
        Image.asset(
          image,
          width: 64,
          height: 64,
        ),
        Text(
          time ?? 'Not Punched',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogout() async {
    try {
      await StorageHelper.deleteUserData();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to logout: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    try {
      _formattedDate = await getFormattedDate();

      Map<String, dynamic> attendStatus =
          await AttendanceService().getAttendanceStatus();
      Map<String, dynamic> dto = attendStatus['dto'] ?? {};

      // Get stored status and handle null values
      final String status =
          await StorageHelper.getAttendanceStatus() ?? dto['lastEntry'];
      final String lastEntry = status;
      final bool isOut = lastEntry == 'IN';

      // Create userData with null safety
      return {
        'isOut': isOut,
        'entry_time': dto['inTime'] != null
            ? DateFormat('hh:mm a').format(DateTime.parse(dto['inTime']))
            : "Not Punched",
        'exit_time': dto['outTime'] != null
            ? DateFormat('hh:mm a').format(DateTime.parse(dto['outTime']))
            : "Not Punched",
        'status': dto['status'] ?? 'unknown',
        'transDate': dto['transDate'],
        'username': dto['accName'] ?? 'User',
        'empId': dto['accId'],
      };
    } catch (e) {
      debugPrint('Error in _loadUserData: $e');
      // Return safe default values
      return lastEntry;
    }
  }

  void _openBottomsheet(BuildContext context, String? transDate) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Punch Out',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldWidget(
                    hintText: 'Enter Remark',
                    controller: _remarkController,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Remark is required';
                      }
                      if (value.length > 30) {
                        return 'Remark should be less than 30 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SlideAction(
                    key: _slideActionKey,
                    text: 'Swipe right to Punch out ->',
                    sliderRotate: false,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    outerColor: Colors.red,
                    innerColor: Colors.white,
                    sliderButtonIcon: const Icon(
                      Icons.double_arrow,
                      color: Colors.red,
                    ),
                    onSubmit: () async {
                      {
                        Navigator.pop(context);
                        await _punchOut(transDate);
                        setState(() {
                          _userDataFuture = _loadUserData();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCameraUI(
      BuildContext context, bool isEntry, String employeeId) async {
    try {
      final XFile? photo = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraUI(isEntry: isEntry)),
      );

      if (photo != null) {
        debugPrint('Photo captured: ${photo.path}');
        setState(() {
          _userDataFuture = _loadUserData();
        });
      }
    } catch (e) {
      debugPrint('Error opening camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open camera: $e')),
        );
      }
    }
  }

  Future<void> _punchOut(String? transDate) async {
    setState(() {
      isLoading = true;
    });
    try {
      await AttendanceService().punchOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Punch out successful!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error punching out: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
        _userDataFuture = _loadUserData();
      });
    }
  }
}
