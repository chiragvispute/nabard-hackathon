import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/auth0_config.dart';
import 'dart:convert';
import 'dart:io';

class AuthService {
  static Auth0? _auth0;
  static Credentials? _credentials;

  static Auth0 get auth0 {
    _auth0 ??= Auth0(Auth0Config.domain, Auth0Config.clientId);
    return _auth0!;
  }

  // Initialize Auth0
  static Future<void> initialize() async {
    _auth0 = Auth0(Auth0Config.domain, Auth0Config.clientId);
    await _loadStoredCredentials();
  }

  // Send OTP to phone number using Auth0 passwordless
  static Future<bool> sendPhoneOTP(String phoneNumber) async {
    try {
      print('DEBUG: Sending OTP to: $phoneNumber');

      // Use direct HTTP request to Auth0's passwordless API
      final client = HttpClient();
      final request = await client.postUrl(
        Uri.parse('https://${Auth0Config.domain}/passwordless/start'),
      );

      request.headers.set('Content-Type', 'application/json');

      final body = json.encode({
        'client_id': Auth0Config.clientId,
        'connection': 'sms',
        'phone_number': phoneNumber,
        'send': 'code',
      });

      print('DEBUG: Send OTP Request body: $body');
      request.write(body);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      print('DEBUG: Send OTP Response status: ${response.statusCode}');
      print('DEBUG: Send OTP Response body: $responseBody');

      if (response.statusCode == 200) {
        // Store phone number for verification
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_phone', phoneNumber);
        client.close();
        return true;
      }

      print('Error sending OTP: ${response.statusCode} - $responseBody');
      client.close();
      return false;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Verify OTP and login using Auth0 passwordless
  static Future<bool> verifyOTPAndLogin(String phoneNumber, String otp) async {
    try {
      print('DEBUG: Verifying OTP: $otp for phone: $phoneNumber');

      // Use direct HTTP request to Auth0's token endpoint
      final client = HttpClient();
      final request = await client.postUrl(
        Uri.parse('https://${Auth0Config.domain}/oauth/token'),
      );

      request.headers.set('Content-Type', 'application/json');

      final body = json.encode({
        'grant_type': 'http://auth0.com/oauth/grant-type/passwordless/otp',
        'client_id': Auth0Config.clientId,
        'username': phoneNumber,
        'otp': otp,
        'realm': 'sms',
        'scope': 'openid profile phone',
      });

      print('DEBUG: Request body: $body');
      request.write(body);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: $responseBody');

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody) as Map<String, dynamic>;
        print('DEBUG: Parsed response data: $responseData');
        print(
          'DEBUG: Access token exists: ${responseData.containsKey('access_token')}',
        );
        print(
          'DEBUG: ID token exists: ${responseData.containsKey('id_token')}',
        );
        print(
          'DEBUG: Refresh token exists: ${responseData.containsKey('refresh_token')}',
        );
        print('DEBUG: Refresh token value: ${responseData['refresh_token']}');

        // Create credentials from response - handle null refresh_token safely
        try {
          // Create a simple user profile from the response data
          final userMap = <String, dynamic>{
            'sub': 'sms|placeholder', // Auth0 requires a sub field
            'phone_number': responseData['phone_number'] ?? '',
          };

          _credentials = Credentials(
            accessToken: responseData['access_token'] as String,
            idToken: responseData['id_token'] as String? ?? '',
            refreshToken:
                responseData['refresh_token'] as String?, // Can be null
            tokenType: responseData['token_type'] as String? ?? 'Bearer',
            expiresAt: DateTime.now().add(
              Duration(seconds: (responseData['expires_in'] as int?) ?? 3600),
            ),
            scopes: {'openid', 'profile', 'phone'},
            user: UserProfile.fromMap(userMap),
          );
          print('DEBUG: Credentials created successfully');
        } catch (e) {
          print('DEBUG: Error creating credentials: $e');
          client.close();
          return false;
        }

        try {
          await _storeCredentials();
          print('DEBUG: Credentials stored successfully');
        } catch (e) {
          print('DEBUG: Error storing credentials: $e');
          client.close();
          return false;
        }

        try {
          await _storeAuthStatus(true);
          print('DEBUG: Auth status stored successfully');
        } catch (e) {
          print('DEBUG: Error storing auth status: $e');
          client.close();
          return false;
        }

        client.close();
        return true;
      }

      print('Error verifying OTP: ${response.statusCode} - $responseBody');
      client.close();
      return false;
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn && _credentials != null) {
      // Check if token is still valid
      if (_credentials!.expiresAt.isAfter(DateTime.now())) {
        return true;
      } else {
        // Token expired, logout
        await logout();
        return false;
      }
    }

    return false;
  }

  // Get current user info (simplified for now)
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    if (_credentials?.accessToken != null) {
      try {
        // For now, return basic info from stored preferences
        final prefs = await SharedPreferences.getInstance();
        final phone = prefs.getString('pending_phone');
        return {'phone': phone};
      } catch (e) {
        print('Error getting user info: $e');
        return null;
      }
    }
    return null;
  }

  // Logout
  static Future<void> logout() async {
    try {
      _credentials = null;
      await _storeAuthStatus(false);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth0_credentials');
      await prefs.remove('pending_phone');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Store auth status
  static Future<void> _storeAuthStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
  }

  // Store credentials
  static Future<void> _storeCredentials() async {
    if (_credentials != null) {
      final prefs = await SharedPreferences.getInstance();
      final credentialsMap = <String, dynamic>{
        'access_token': _credentials!.accessToken,
        'id_token': _credentials!.idToken,
        'refresh_token': _credentials!.refreshToken, // Can be null
        'token_type': _credentials!.tokenType,
        'expires_at': _credentials!.expiresAt.toIso8601String(),
      };
      await prefs.setString('auth0_credentials', json.encode(credentialsMap));
    }
  }

  // Load stored credentials
  static Future<void> _loadStoredCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final credentialsString = prefs.getString('auth0_credentials');

      if (credentialsString != null) {
        final credentialsMap =
            json.decode(credentialsString) as Map<String, dynamic>;
        final expiresAt = DateTime.parse(
          credentialsMap['expires_at'] as String,
        );

        if (expiresAt.isAfter(DateTime.now())) {
          _credentials = Credentials(
            accessToken: credentialsMap['access_token'] as String,
            idToken: credentialsMap['id_token'] as String? ?? '',
            refreshToken:
                credentialsMap['refresh_token'] as String?, // Can be null
            tokenType: credentialsMap['token_type'] as String? ?? 'Bearer',
            expiresAt: expiresAt,
            scopes: {'openid', 'profile', 'phone'},
            user: UserProfile.fromMap({}),
          );
        } else {
          // Credentials expired
          await logout();
        }
      }
    } catch (e) {
      print('Error loading credentials: $e');
      await logout();
    }
  }
}
