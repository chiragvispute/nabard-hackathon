import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../home_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final String phoneNumber;

  const LanguageSelectionScreen({super.key, required this.phoneNumber});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'code': 'en', 'native': 'English'},
    {'name': 'Hindi', 'code': 'hi', 'native': 'हिंदी'},
    {'name': 'Marathi', 'code': 'mr', 'native': 'मराठी'},
    {'name': 'Gujarati', 'code': 'gu', 'native': 'ગુજરાતી'},
    {'name': 'Tamil', 'code': 'ta', 'native': 'தமிழ்'},
    {'name': 'Telugu', 'code': 'te', 'native': 'తెలుగు'},
    {'name': 'Kannada', 'code': 'kn', 'native': 'ಕನ್ನಡ'},
    {'name': 'Malayalam', 'code': 'ml', 'native': 'മലയാളം'},
    {'name': 'Punjabi', 'code': 'pa', 'native': 'ਪੰਜਾਬੀ'},
    {'name': 'Bengali', 'code': 'bn', 'native': 'বাংলা'},
  ];

  void _continueToRegistration() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => UserRegistrationScreen(
              phoneNumber: widget.phoneNumber,
              selectedLanguage: _selectedLanguage,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Header
              const Text(
                'Welcome to NABARD',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Carbon Credit Platform',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              const Text(
                'Select your preferred language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'अपनी पसंदीदा भाषा चुनें',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Language List
              Expanded(
                child: ListView.builder(
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isSelected = _selectedLanguage == language['name'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedLanguage = language['name']!;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected ? Colors.green : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color:
                                isSelected
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        isSelected ? Colors.green : Colors.grey,
                                    width: 2,
                                  ),
                                  color:
                                      isSelected
                                          ? Colors.green
                                          : Colors.transparent,
                                ),
                                child:
                                    isSelected
                                        ? const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      language['native']!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isSelected
                                                ? Colors.green
                                                : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      language['name']!,
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
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _continueToRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class UserRegistrationScreen extends StatefulWidget {
  final String phoneNumber;
  final String selectedLanguage;

  const UserRegistrationScreen({
    super.key,
    required this.phoneNumber,
    required this.selectedLanguage,
  });

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _farmSizeController = TextEditingController();
  final _locationController = TextEditingController();
  final _aadhaarController = TextEditingController();

  bool _consentGiven = false;
  bool _isLoading = false;
  String _selectedFarmType = 'Crop Farming';
  String _selectedState = 'Maharashtra';

  final List<String> _farmTypes = [
    'Crop Farming',
    'Dairy Farming',
    'Poultry Farming',
    'Mixed Farming',
    'Organic Farming',
    'Horticulture',
    'Aquaculture',
  ];

  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide consent to continue'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userService = UserService();
      final success = await userService.registerUser(
        phoneNumber: widget.phoneNumber,
        fullName: _fullNameController.text.trim(),
        language: widget.selectedLanguage,
        farmSize: double.parse(_farmSizeController.text.trim()),
        farmType: _selectedFarmType,
        location: _locationController.text.trim(),
        state: _selectedState,
        aadhaarNumber: _aadhaarController.text.trim(),
        consentGiven: _consentGiven,
      );

      if (success && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Complete Registration',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tell us about yourself',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Phone: ${widget.phoneNumber}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Farm Size
                TextFormField(
                  controller: _farmSizeController,
                  decoration: const InputDecoration(
                    labelText: 'Farm Size (in acres) *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.landscape),
                    suffixText: 'acres',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter farm size';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Farm Type Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedFarmType,
                  decoration: const InputDecoration(
                    labelText: 'Farm Type *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.agriculture),
                  ),
                  items:
                      _farmTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedFarmType = value!);
                  },
                ),
                const SizedBox(height: 16),

                // Village/Location
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Village/City *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your village/city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // State Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  decoration: const InputDecoration(
                    labelText: 'State *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.map),
                  ),
                  items:
                      _states.map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedState = value!);
                  },
                ),
                const SizedBox(height: 16),

                // Aadhaar Number
                TextFormField(
                  controller: _aadhaarController,
                  decoration: const InputDecoration(
                    labelText: 'Aadhaar Number *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.credit_card),
                    hintText: 'XXXX XXXX XXXX',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Aadhaar number';
                    }
                    if (value.replaceAll(' ', '').length != 12) {
                      return 'Please enter a valid 12-digit Aadhaar number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Consent Checkbox
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Sharing Consent',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        value: _consentGiven,
                        onChanged: (value) {
                          setState(() => _consentGiven = value ?? false);
                        },
                        title: const Text(
                          'I agree to share my farm data for carbon credit calculations and environmental monitoring purposes',
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: const Text(
                          'Your data will be used only for carbon credit verification and will be kept secure',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitRegistration,
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
                              'Complete Registration',
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
    _fullNameController.dispose();
    _farmSizeController.dispose();
    _locationController.dispose();
    _aadhaarController.dispose();
    super.dispose();
  }
}
