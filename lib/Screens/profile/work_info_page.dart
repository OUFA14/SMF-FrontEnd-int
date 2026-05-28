import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '../../utils/navigation_helper.dart';
import '../../services/auth_service.dart';
import '../../services/users_service.dart';
import '../../models/work_info.dart';

class WorkInfoPage extends StatefulWidget {
  const WorkInfoPage({super.key});

  @override
  State<WorkInfoPage> createState() => _WorkInfoPageState();
}

class _WorkInfoPageState extends State<WorkInfoPage> {
  bool _isEditing = false;
  bool _isLoading = true;
  WorkInfo? _workInfo;

  final _jobTitleCtrl = TextEditingController();
  final _departmentCtrl = TextEditingController();
  final _managerCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _shiftCtrl = TextEditingController();
  final _certificatesCtrl = TextEditingController();
  final _safetyCoursesCtrl = TextEditingController();
  final _equipmentCtrl = TextEditingController();

  String _employmentStatus = "Active";
  String _attendanceStatus = "Present";

  final List<String> _employmentOptions = ["Active", "On Leave", "Remote"];
  final List<String> _attendanceOptions = ["Present", "Absent", "On Break"];

  @override
  void initState() {
    super.initState();
    _loadWorkInfo();
  }

  Future<void> _loadWorkInfo() async {
    final userId = AuthService.instance.userId;
    if (userId == null || userId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final workInfo = await UsersService().getWorkInfo(userId);
      setState(() {
        _workInfo = workInfo;
        _jobTitleCtrl.text = workInfo.jobTitle;
        _departmentCtrl.text = workInfo.department;
        _managerCtrl.text = workInfo.manager;
        _locationCtrl.text = workInfo.location;
        _shiftCtrl.text = workInfo.shift;
        _certificatesCtrl.text = workInfo.certificates;
        _safetyCoursesCtrl.text = workInfo.safetyCourses;
        _equipmentCtrl.text = workInfo.equipment;
        _employmentStatus = workInfo.employmentStatus;
        _attendanceStatus = workInfo.attendanceStatus;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _toggleEdit() async {
    if (_isEditing) {
      final userId = AuthService.instance.userId;
      if (userId != null && userId.isNotEmpty) {
        final updatedWorkInfo = WorkInfo(
          jobTitle: _jobTitleCtrl.text,
          department: _departmentCtrl.text,
          manager: _managerCtrl.text,
          location: _locationCtrl.text,
          shift: _shiftCtrl.text,
          certificates: _certificatesCtrl.text,
          safetyCourses: _safetyCoursesCtrl.text,
          equipment: _equipmentCtrl.text,
          employmentStatus: _employmentStatus,
          attendanceStatus: _attendanceStatus,
        );

        try {
          await UsersService().updateWorkInfo(userId, updatedWorkInfo);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Work information saved successfully ✓")),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error saving: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
    setState(() => _isEditing = !_isEditing);
  }

  @override
  void dispose() {
    _jobTitleCtrl.dispose();
    _departmentCtrl.dispose();
    _managerCtrl.dispose();
    _locationCtrl.dispose();
    _shiftCtrl.dispose();
    _certificatesCtrl.dispose();
    _safetyCoursesCtrl.dispose();
    _equipmentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final themeProvider = context.watch<ThemeProvider>();
    final lang = context.watch<LanguageProvider>();
    final isDark = themeProvider.isDarkMode;
    final bgColor = isDark ? const Color(0xFF0A1628) : const Color(0xFFF4F6FA);
    final cardColor = isDark ? const Color(0xFF111C30) : Colors.white;
    final borderColor = isDark ? Colors.white.withOpacity(0.07) : Colors.grey.withOpacity(0.15);

    return WillPopScope(
      onWillPop: () => AppNavigation.handleSystemBack(context, fallbackRoute: '/profile'),
      child: Directionality(
        textDirection: lang.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF0A1628) : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
              onPressed: () => AppNavigation.goBack(context, fallbackRoute: '/profile'),
            ),
            title: Text(
              lang.isArabic ? "معلومات العمل" : "Work Information",
              style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton.icon(
                  onPressed: _toggleEdit,
                  icon: Icon(_isEditing ? Icons.check : Icons.edit_outlined, size: 18, color: _isEditing ? Colors.green : Colors.blueAccent),
                  label: Text(
                    _isEditing ? (lang.isArabic ? "حفظ" : "Save") : (lang.isArabic ? "تعديل" : "Edit"),
                    style: TextStyle(color: _isEditing ? Colors.green : Colors.blueAccent, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(isDark, icon: Icons.work_outline, label: lang.isArabic ? "بيانات الموظف" : "Employee Data"),
                const SizedBox(height: 12),
                _card(cardColor, borderColor, [
                  _field(isDark, label: lang.isArabic ? "المسمى الوظيفي" : "Job Title", ctrl: _jobTitleCtrl, icon: Icons.badge_outlined),
                  _field(isDark, label: lang.isArabic ? "القسم" : "Department", ctrl: _departmentCtrl, icon: Icons.business_outlined),
                  _field(isDark, label: lang.isArabic ? "اسم المدير" : "Manager Name", ctrl: _managerCtrl, icon: Icons.person_outline),
                  _field(isDark, label: lang.isArabic ? "موقع العمل" : "Work Location", ctrl: _locationCtrl, icon: Icons.location_on_outlined),
                  _field(isDark, label: lang.isArabic ? "جدول الوردية" : "Shift Schedule", ctrl: _shiftCtrl, icon: Icons.schedule_outlined),
                ]),
                const SizedBox(height: 24),
                _sectionHeader(isDark, icon: Icons.school_outlined, label: lang.isArabic ? "المؤهلات والتدريب" : "Qualifications & Training", accent: Colors.teal),
                const SizedBox(height: 12),
                _card(cardColor, borderColor, [
                  _field(isDark, label: lang.isArabic ? "الشهادات التدريبية" : "Training Certificates", ctrl: _certificatesCtrl, icon: Icons.workspace_premium_outlined),
                  _field(isDark, label: lang.isArabic ? "دورات السلامة المكتملة" : "Safety Courses Completed", ctrl: _safetyCoursesCtrl, icon: Icons.health_and_safety_outlined),
                  _field(isDark, label: lang.isArabic ? "المعدات المخصصة" : "Equipment Assigned", ctrl: _equipmentCtrl, icon: Icons.devices_outlined),
                ]),
                const SizedBox(height: 24),
                _sectionHeader(isDark, icon: Icons.toggle_on_outlined, label: lang.isArabic ? "الحالة" : "Status", accent: Colors.orange),
                const SizedBox(height: 12),
                _card(cardColor, borderColor, [
                  _dropdownRow(isDark, label: lang.isArabic ? "حالة التوظيف" : "Employment Status", icon: Icons.work_history_outlined, value: _employmentStatus, options: _employmentOptions, chipColors: {"Active": Colors.green, "On Leave": Colors.orange, "Remote": Colors.blueAccent}, onChanged: (v) => setState(() => _employmentStatus = v!)),
                  _dropdownRow(isDark, label: lang.isArabic ? "حالة الحضور" : "Attendance Status", icon: Icons.how_to_reg_outlined, value: _attendanceStatus, options: _attendanceOptions, chipColors: {"Present": Colors.green, "Absent": Colors.red, "On Break": Colors.orange}, onChanged: (v) => setState(() => _attendanceStatus = v!)),
                ]),
                const SizedBox(height: 28),
                if (_isEditing)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: _toggleEdit,
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: Text(lang.isArabic ? "حفظ التغييرات" : "Save Changes", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(bool isDark, {required IconData icon, required String label, Color accent = Colors.blueAccent}) {
    return Row(children: [
      Icon(icon, color: accent, size: 18),
      const SizedBox(width: 8),
      Text(label, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.4)),
    ]);
  }

  Widget _card(Color cardColor, Color borderColor, List<Widget> children) {
    final divider = Divider(height: 1, color: borderColor, indent: 16, endIndent: 16);
    final rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i < children.length - 1) rows.add(divider);
    }
    return Container(
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
      child: Column(children: rows),
    );
  }

  Widget _field(bool isDark, {required String label, required TextEditingController ctrl, required IconData icon, TextInputType type = TextInputType.text}) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white38 : Colors.black38;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(children: [
        Icon(icon, size: 18, color: subColor),
        const SizedBox(width: 12),
        Expanded(
          child: _isEditing
              ? TextField(
                  controller: ctrl,
                  keyboardType: type,
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(labelText: label, labelStyle: TextStyle(color: subColor, fontSize: 12), border: InputBorder.none, isDense: true),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: TextStyle(color: subColor, fontSize: 11)),
                      const SizedBox(height: 3),
                      Text(ctrl.text.isEmpty ? "—" : ctrl.text, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
        ),
        if (_isEditing) Icon(Icons.edit, size: 14, color: isDark ? Colors.white24 : Colors.black26),
      ]),
    );
  }

  Widget _dropdownRow(
    bool isDark, {
    required String label,
    required IconData icon,
    required String value,
    required List<String> options,
    required Map<String, Color> chipColors,
    required ValueChanged<String?> onChanged,
  }) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white38 : Colors.black38;
    final chipColor = chipColors[value] ?? Colors.blueAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(children: [
        Icon(icon, size: 18, color: subColor),
        const SizedBox(width: 12),
        Expanded(
          child: _isEditing
              ? DropdownButtonFormField<String>(
                  value: value,
                  dropdownColor: isDark ? const Color(0xFF111C30) : Colors.white,
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(labelText: label, labelStyle: TextStyle(color: subColor, fontSize: 12), border: InputBorder.none, isDense: true),
                  items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                  onChanged: onChanged,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: TextStyle(color: subColor, fontSize: 11)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: chipColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: chipColor.withOpacity(0.4))),
                        child: Text(value, style: TextStyle(color: chipColor, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
        ),
        if (_isEditing) Icon(Icons.edit, size: 14, color: isDark ? Colors.white24 : Colors.black26),
      ]),
    );
  }
}
