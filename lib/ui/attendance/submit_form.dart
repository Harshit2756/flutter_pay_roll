import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pay_roll/services/attendance_service.dart';
import 'package:pay_roll/shared/contants.dart';
import 'package:pay_roll/shared/widgets/background.dart';
import 'package:pay_roll/shared/widgets/text_form_field.dart';
import 'package:pay_roll/ui/attendance/camera_uid.dart';
import 'package:pay_roll/ui/bottom_nav_bar.dart';

class SubmitForm extends StatefulWidget {
  final XFile? photo;
  final bool isEntry;

  const SubmitForm({
    super.key,
    required this.photo,
    required this.isEntry,
  });


  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  bool _isLoading = false;
  final AttendanceService _attendanceService = AttendanceService();
  String _selectedStatus = 'present';
  final TextEditingController _remarksController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.isEntry ? 'SUBMIT ENTRY' : 'SUBMIT EXIT'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildImage(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('Present'),
                  _buildButton('WFH'),
                  _buildButton('HalfDay'),
                ],
              ),
              const SizedBox(height: 32),
              TextFormFieldWidget(
                controller: _remarksController,
                hintText: 'Enter remarks (If any)',
                prefixIcon: Icons.comment_outlined,
                keyboardType: TextInputType.text,
                isRequired: false,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _retakePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Retake Photo'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: primaryColor,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 8,
                        shadowColor: primaryColor..withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleSubmit,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(_isLoading ? 'Submitting...' : 'Submit'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 8,
                        shadowColor: Colors.grey..withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Widget _buildButton(String label) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey..withValues(alpha: 0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedStatus = label.toLowerCase();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedStatus == label.toLowerCase()
              ? primaryColor
              : Colors.white,
          foregroundColor: _selectedStatus == label.toLowerCase()
              ? Colors.white
              : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: primaryColor),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.photo != null) {
      if (kIsWeb) {
        return Image.network(
          widget.photo!.path,
          fit: BoxFit.cover,
        );
      } else {
        return Image.file(
          File(widget.photo!.path),
          fit: BoxFit.cover,
        );
      }
    }
    return const Center(child: Text('No image available'));
  }


  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _attendanceService.punchIn();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully submitted!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error submitting: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _retakePhoto() async {
    final XFile? newPhoto = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CameraUI(isEntry: widget.isEntry)),
    );

    if (newPhoto != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SubmitForm(photo: newPhoto, isEntry: widget.isEntry),
        ),
      );
    }
  }
}
