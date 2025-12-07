import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/health_record.dart';
import '../providers/health_record_provider.dart';

class AddEditRecordScreen extends StatefulWidget {
  final HealthRecord? record;

  const AddEditRecordScreen({super.key, this.record});

  @override
  State<AddEditRecordScreen> createState() => _AddEditRecordScreenState();
}

class _AddEditRecordScreenState extends State<AddEditRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _dateController;
  late TextEditingController _stepsController;
  late TextEditingController _caloriesController;
  late TextEditingController _waterController;

  final FocusNode _dateFocus = FocusNode();
  final FocusNode _stepsFocus = FocusNode();
  final FocusNode _caloriesFocus = FocusNode();
  final FocusNode _waterFocus = FocusNode();

  static const Color _green = Color(0xFF16A34A);

  @override
  void initState() {
    super.initState();
    final record = widget.record;
    _dateController = TextEditingController(
      text: record?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    _stepsController =
        TextEditingController(text: record?.steps.toString() ?? '');
    _caloriesController =
        TextEditingController(text: record?.calories.toString() ?? '');
    _waterController =
        TextEditingController(text: record?.water.toString() ?? '');

    for (final node in [
      _dateFocus,
      _stepsFocus,
      _caloriesFocus,
      _waterFocus,
    ]) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _stepsController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();

    _dateFocus.dispose();
    _stepsFocus.dispose();
    _caloriesFocus.dispose();
    _waterFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final currentDate =
        DateTime.tryParse(_dateController.text) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  String? _validateInt(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 0) {
      return 'Enter a valid non-negative number';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    Provider.of<HealthRecordProvider>(context, listen: false);

    final record = HealthRecord(
      id: widget.record?.id,
      date: _dateController.text.trim(),
      steps: int.parse(_stepsController.text),
      calories: int.parse(_caloriesController.text),
      water: int.parse(_waterController.text),
    );

    final bool isNew = widget.record == null;

    if (isNew) {
      await provider.addRecord(record);
    } else {
      await provider.updateRecord(record);
    }

    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentMaterialBanner();

    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.white,
        elevation: 2,
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 1.4),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.check,
                color: Colors.green,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              isNew
                  ? 'Record Added Successfully'
                  : 'Record Updated Successfully',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => messenger.hideCurrentMaterialBanner(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      messenger.hideCurrentMaterialBanner();
    });

    Navigator.of(context).pop();
  }

  InputDecoration _pillDecoration({
    required String label,
    required IconData icon,
    required bool isActive,
  }) {
    final iconColor = isActive ? _green : Colors.grey.shade600;

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: iconColor),
      filled: true,
      fillColor: const Color(0xFFF7F8F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
        borderSide: BorderSide(
          color: _green,
          width: 1.5,
        ),
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.record != null;
    final textTheme = Theme.of(context).textTheme;

    final isDateActive =
        _dateFocus.hasFocus || _dateController.text.isNotEmpty;
    final isStepsActive =
        _stepsFocus.hasFocus || _stepsController.text.isNotEmpty;
    final isCaloriesActive =
        _caloriesFocus.hasFocus || _caloriesController.text.isNotEmpty;
    final isWaterActive =
        _waterFocus.hasFocus || _waterController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Record' : 'Add Record'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing
                            ? 'Update Your Health Entry'
                            : 'Add Your Daily Stats',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Keep Track of Your Daily Steps, Calories and Water.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: _dateFocus,
                        controller: _dateController,
                        readOnly: true,
                        decoration: _pillDecoration(
                          label: 'Date',
                          icon: Icons.calendar_month_rounded,
                          isActive: isDateActive,
                        ),
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 14),

                      // Steps
                      TextFormField(
                        focusNode: _stepsFocus,
                        controller: _stepsController,
                        keyboardType: TextInputType.number,
                        decoration: _pillDecoration(
                          label: 'Steps Walked',
                          icon: Icons.directions_walk_rounded,
                          isActive: isStepsActive,
                        ),
                        validator: (value) =>
                            _validateInt(value, 'Steps'),
                      ),
                      const SizedBox(height: 14),

                      // Calories
                      TextFormField(
                        focusNode: _caloriesFocus,
                        controller: _caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: _pillDecoration(
                          label: 'Calories Burned',
                          icon: Icons.local_fire_department_rounded,
                          isActive: isCaloriesActive,
                        ),
                        validator: (value) =>
                            _validateInt(value, 'Calories'),
                      ),
                      const SizedBox(height: 14),

                      // Water
                      TextFormField(
                        focusNode: _waterFocus,
                        controller: _waterController,
                        keyboardType: TextInputType.number,
                        decoration: _pillDecoration(
                          label: 'Water Intake (ml)',
                          icon: Icons.water_drop_rounded,
                          isActive: isWaterActive,
                        ),
                        validator: (value) =>
                            _validateInt(value, 'Water'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_rounded),
                    label: Text(
                      isEditing ? 'Update Record' : 'Save Record',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
