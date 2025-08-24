import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../services/auth_service.dart';
import '../../home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 30;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _resendTimer--);
        return _resendTimer > 0;
      }
      return false;
    }).then((_) {
      if (mounted) setState(() => _canResend = true);
    });
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      _showErrorSnackBar('Please enter complete OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.verifyOTPAndLogin(
        widget.phoneNumber,
        _otpController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        _showErrorSnackBar('Invalid OTP. Please try again.');
        _otpController.clear();
      }
    } catch (e) {
      _showErrorSnackBar('Error verifying OTP: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOTP() async {
    setState(() => _isLoading = true);

    try {
      final success = await AuthService.sendPhoneOTP(widget.phoneNumber);

      if (success) {
        _startResendTimer();
        _showSuccessSnackBar('OTP sent successfully');
      } else {
        _showErrorSnackBar('Failed to resend OTP');
      }
    } catch (e) {
      _showErrorSnackBar('Error resending OTP: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  String get _maskedPhoneNumber {
    final phone = widget.phoneNumber;
    if (phone.length > 6) {
      return '${phone.substring(0, 3)}****${phone.substring(phone.length - 2)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.green),
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.green.withOpacity(0.1),
        border: Border.all(color: Colors.green),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Verify your phone',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter the 6-digit code sent to $_maskedPhoneNumber',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),

                // OTP Input
                Center(
                  child: Pinput(
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    onCompleted: (_) => _verifyOTP(),
                  ),
                ),

                const SizedBox(height: 40),

                // Resend OTP
                Center(
                  child: TextButton(
                    onPressed: _canResend && !_isLoading ? _resendOTP : null,
                    child: Text(
                      _canResend
                          ? 'Resend OTP'
                          : 'Resend OTP in ${_resendTimer}s',
                      style: TextStyle(
                        color: _canResend ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Verify button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                            : const Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
