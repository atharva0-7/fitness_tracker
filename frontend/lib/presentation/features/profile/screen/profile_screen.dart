import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/utils/all_utils.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/user_profile.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _isEditing = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await DataService.getUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
      _updateControllers();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AllUtils.showErrorSnackBar(context, 'Failed to load profile: $e');
    }
  }

  void _updateControllers() {
    if (_userProfile != null) {
      _nameController.text = _userProfile!.name;
      _emailController.text = _userProfile!.email;
      _heightController.text = _userProfile!.height.toString();
      _weightController.text = _userProfile!.weight.toString();
      _dateOfBirthController.text = AllUtils.formatDate(
        _userProfile!.dateOfBirth,
      );
    }
  }

  Future<void> _saveProfile() async {
    try {
      if (_userProfile != null) {
        final updatedProfile = _userProfile!.copyWith(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          height:
              double.tryParse(_heightController.text) ?? _userProfile!.height,
          weight:
              double.tryParse(_weightController.text) ?? _userProfile!.weight,
          updatedAt: DateTime.now(),
        );

        await DataService.saveUserProfile(updatedProfile);

        setState(() {
          _userProfile = updatedProfile;
          _isEditing = false;
        });

        AllUtils.showSuccessSnackBar(context, 'Profile updated successfully!');
      }
    } catch (e) {
      AllUtils.showErrorSnackBar(context, 'Failed to save profile: $e');
    }
  }

  Future<void> _exportData() async {
    try {
      await DataService.exportAllData(_userProfile!.id);
      // In a real app, you would save this to a file or share it
      AllUtils.showInfoSnackBar(context, 'Data exported successfully!');
    } catch (e) {
      AllUtils.showErrorSnackBar(context, 'Failed to export data: $e');
    }
  }

  Future<void> _clearData() async {
    final confirmed = await AllUtils.showConfirmDialog(
      context,
      title: 'Clear All Data',
      content:
          'Are you sure you want to clear all your data? This action cannot be undone.',
      confirmText: 'Clear',
      cancelText: 'Cancel',
    );

    if (confirmed == true) {
      try {
        await DataService.clearAllData();
        AllUtils.showSuccessSnackBar(context, 'All data cleared successfully!');
        _loadProfile();
      } catch (e) {
        AllUtils.showErrorSnackBar(context, 'Failed to clear data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AllUtils.isMobile(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(child: AllUtils.buildLoadingIndicator(size: 50)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: AllUtils.getResponsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF6C5CE7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AllUtils.getResponsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(isMobile),

            SizedBox(height: AllUtils.getResponsivePadding(context)),

            // Personal Information
            _buildPersonalInfo(isMobile),

            SizedBox(height: AllUtils.getResponsivePadding(context)),

            // Health Stats
            _buildHealthStats(isMobile),

            SizedBox(height: AllUtils.getResponsivePadding(context)),

            // Settings
            _buildSettings(isMobile),

            SizedBox(height: AllUtils.getResponsivePadding(context)),

            // Data Management
            _buildDataManagement(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF9B59B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: isMobile ? 80 : 100,
            height: isMobile ? 80 : 100,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),

          SizedBox(height: isMobile ? 12 : 16),

          // Name and Email
          Text(
            _userProfile!.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: AllUtils.getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _userProfile!.email,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: AllUtils.getResponsiveFontSize(context, 16),
            ),
          ),

          SizedBox(height: isMobile ? 12 : 16),

          // Member Since
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Member since ${AllUtils.formatDate(_userProfile!.createdAt)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: AllUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),

          // Name
          _buildInfoField(
            'Name',
            _nameController,
            Icons.person,
            isMobile,
            enabled: _isEditing,
          ),

          SizedBox(height: isMobile ? 12 : 16),

          // Email
          _buildInfoField(
            'Email',
            _emailController,
            Icons.email,
            isMobile,
            enabled: _isEditing,
          ),

          SizedBox(height: isMobile ? 12 : 16),

          // Date of Birth
          _buildInfoField(
            'Date of Birth',
            _dateOfBirthController,
            Icons.cake,
            isMobile,
            enabled: _isEditing,
            onTap: _isEditing ? _selectDateOfBirth : null,
          ),

          SizedBox(height: isMobile ? 12 : 16),

          // Gender
          _buildDropdownField(
            'Gender',
            _userProfile!.gender,
            ['Male', 'Female', 'Other'],
            Icons.person_outline,
            isMobile,
            enabled: _isEditing,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _userProfile = _userProfile!.copyWith(gender: value);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStats(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Statistics',
            style: TextStyle(
              fontSize: AllUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),

          Row(
            children: [
              Expanded(
                child: _buildStatField(
                  'Height',
                  _heightController,
                  'cm',
                  Icons.height,
                  isMobile,
                  enabled: _isEditing,
                ),
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: _buildStatField(
                  'Weight',
                  _weightController,
                  'kg',
                  Icons.monitor_weight,
                  isMobile,
                  enabled: _isEditing,
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 12 : 16),

          // BMI Display
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: AllUtils.getBMIColor(
                _userProfile!.bmi,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AllUtils.getBMIColor(
                  _userProfile!.bmi,
                ).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: AllUtils.getBMIColor(_userProfile!.bmi),
                  size: isMobile ? 24 : 30,
                ),
                SizedBox(width: isMobile ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BMI: ${AllUtils.formatNumber(_userProfile!.bmi, decimals: 1)}',
                        style: TextStyle(
                          fontSize: AllUtils.getResponsiveFontSize(context, 16),
                          fontWeight: FontWeight.bold,
                          color: AllUtils.getBMIColor(_userProfile!.bmi),
                        ),
                      ),
                      Text(
                        _userProfile!.bmiCategory,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: AllUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),

          _buildSettingItem(
            'Notifications',
            'Manage your notification preferences',
            Icons.notifications,
            () {},
            isMobile,
          ),

          _buildSettingItem(
            'Privacy',
            'Control your privacy settings',
            Icons.privacy_tip,
            () {},
            isMobile,
          ),

          _buildSettingItem(
            'Units',
            'Change measurement units',
            Icons.straighten,
            () {},
            isMobile,
          ),

          _buildSettingItem(
            'Theme',
            'Customize app appearance',
            Icons.palette,
            () {},
            isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagement(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Management',
            style: TextStyle(
              fontSize: AllUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),

          _buildSettingItem(
            'Export Data',
            'Download your data as JSON',
            Icons.download,
            _exportData,
            isMobile,
          ),

          _buildSettingItem(
            'Clear All Data',
            'Remove all your data from the app',
            Icons.delete_forever,
            _clearData,
            isMobile,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller,
    IconData icon,
    bool isMobile, {
    bool enabled = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: isMobile ? 4 : 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          onTap: onTap,
          readOnly: onTap != null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildStatField(
    String label,
    TextEditingController controller,
    String unit,
    IconData icon,
    bool isMobile, {
    bool enabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: isMobile ? 4 : 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            suffixText: unit,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    IconData icon,
    bool isMobile, {
    bool enabled = false,
    ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: isMobile ? 4 : 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[50],
          ),
          items:
              options
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool isMobile, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : const Color(0xFF6C5CE7),
        size: isMobile ? 20 : 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AllUtils.getResponsiveFontSize(context, 16),
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: isMobile ? 12 : 14, color: Colors.grey[600]),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey[400],
        size: isMobile ? 16 : 20,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: isMobile ? 4 : 8,
      ),
    );
  }

  Future<void> _selectDateOfBirth() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _userProfile!.dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      _dateOfBirthController.text = AllUtils.formatDate(date);
      setState(() {
        _userProfile = _userProfile!.copyWith(dateOfBirth: date);
      });
    }
  }
}
