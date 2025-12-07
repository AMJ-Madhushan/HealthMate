import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/health_record_provider.dart';
import '../models/health_record.dart';
import 'add_edit_record_screen.dart';

class RecordListScreen extends StatefulWidget {
  const RecordListScreen({super.key});

  @override
  State<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  final _searchController = TextEditingController();
  static const Color _green = Color(0xFF16A34A);

  @override
  void initState() {
    super.initState();
    final provider =
    Provider.of<HealthRecordProvider>(context, listen: false);
    provider.loadRecords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickSearchDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(picked);
      _searchController.text = dateStr;
      Provider.of<HealthRecordProvider>(context, listen: false)
          .setSearchQuery(dateStr);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    Provider.of<HealthRecordProvider>(context, listen: false)
        .setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthRecordProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(' View Health Records'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              readOnly: true,
              onTap: _pickSearchDate,
              decoration: InputDecoration(
                labelText: 'Search by date (YYYY-MM-DD)',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: _clearSearch,
                      ),
                    const SizedBox(width: 4),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _green,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.calendar_month_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: _pickSearchDate,
                      ),
                    ),
                  ],
                ),
                filled: true,
                fillColor: Colors.white,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.records.isEmpty
                ? Center(
              child: Text(
                'No Records Yet.\nTap + to Add Your Entry.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            )
                : ListView.builder(
              padding:
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: provider.records.length,
              itemBuilder: (context, index) {
                final HealthRecord record =
                provider.records[index];

                String weekday = '';
                final parsed =
                DateTime.tryParse(record.date);
                if (parsed != null) {
                  weekday =
                      DateFormat('EEEE').format(parsed);
                }

                return Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE4F5EA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: _green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (weekday.isNotEmpty)
                                  Text(
                                    weekday,
                                    style: textTheme
                                        .bodySmall
                                        ?.copyWith(
                                      color: Colors
                                          .grey.shade600,
                                    ),
                                  ),
                                Text(
                                  record.date,
                                  style: textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _FilledIconCircleButton(
                            icon: Icons.edit_rounded,
                            color: _green,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddEditRecordScreen(
                                        record: record,
                                      ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          _FilledIconCircleButton(
                            icon: Icons.delete_rounded,
                            color: Colors.red,
                            onPressed: () async {
                              final confirm =
                              await showDialog<bool>(
                                context: context,
                                builder: (ctx) =>
                                    AlertDialog(
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(24),
                                      ),
                                      title: Text(
                                        'Delete Record',
                                        style: textTheme
                                            .titleMedium
                                            ?.copyWith(
                                          fontWeight:
                                          FontWeight.w600,
                                        ),
                                      ),
                                      content: const Text(
                                        'Are you sure you want to delete this record?',
                                      ),
                                      actionsPadding:
                                      const EdgeInsets
                                          .fromLTRB(
                                          16, 0, 16, 16),
                                      actions: [
                                        Row(
                                          children: [

                                            Expanded(
                                              child:
                                              OutlinedButton(
                                                style: OutlinedButton
                                                    .styleFrom(
                                                  side:
                                                  const BorderSide(
                                                    color: Colors
                                                        .black87,
                                                  ),
                                                  foregroundColor:
                                                  Colors
                                                      .black87,
                                                  padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                    vertical:
                                                    10,
                                                  ),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        999),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(
                                                        ctx)
                                                        .pop(
                                                        false),
                                                child:
                                                const Text(
                                                  'Cancel',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                                width: 12),

                                            Expanded(
                                              child:
                                              OutlinedButton(
                                                style: OutlinedButton
                                                    .styleFrom(
                                                  side:
                                                  const BorderSide(
                                                    color: Colors
                                                        .red,
                                                  ),
                                                  foregroundColor:
                                                  Colors.red,
                                                  padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                    vertical:
                                                    10,
                                                  ),
                                                  shape:
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        999),
                                                  ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(
                                                        ctx)
                                                        .pop(
                                                        true),
                                                child:
                                                const Text(
                                                  'Delete',
                                                  style:
                                                  TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                              );

                              if (confirm == true &&
                                  record.id != null) {
                                await provider
                                    .deleteRecord(
                                    record.id!);
                              }

                              if (context.mounted &&
                                  confirm == true) {
                                final messenger =
                                ScaffoldMessenger.of(
                                    context);

                                messenger
                                    .hideCurrentMaterialBanner();

                                messenger
                                    .showMaterialBanner(
                                  MaterialBanner(
                                    backgroundColor:
                                    Colors.white,
                                    elevation: 2,
                                    content: Row(
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration:
                                          BoxDecoration(
                                            shape: BoxShape
                                                .circle,
                                            border: Border.all(
                                                color: Colors
                                                    .red,
                                                width: 1.4),
                                            color:
                                            Colors.white,
                                          ),
                                          alignment:
                                          Alignment
                                              .center,
                                          child:
                                          const Text(
                                            '!',
                                            style:
                                            TextStyle(
                                              color: Colors
                                                  .red,
                                              fontWeight:
                                              FontWeight
                                                  .w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            width: 10),
                                        const Text(
                                          'Record Deleted Successfully',
                                          style: TextStyle(
                                            color:
                                            Colors.red,
                                            fontWeight:
                                            FontWeight
                                                .w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            messenger
                                                .hideCurrentMaterialBanner(),
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(
                                              color: Colors
                                                  .red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                Future.delayed(
                                    const Duration(
                                        seconds: 2), () {
                                  if (mounted) {
                                    messenger
                                        .hideCurrentMaterialBanner();
                                  }
                                });
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      _RecordMetricCard(
                        title: 'Steps',
                        value:
                        '${record.steps} steps',
                        icon: Icons
                            .directions_walk_rounded,
                        iconColor:
                        const Color(0xFF16A34A),
                        gradient:
                        const LinearGradient(
                          colors: [
                            Color(0xFFDCFCE7),
                            Color(0xFFBBF7D0)
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      _RecordMetricCard(
                        title: 'Calories',
                        value:
                        '${record.calories} cal',
                        icon: Icons
                            .local_fire_department_rounded,
                        iconColor:
                        const Color(0xFFF97316),
                        gradient:
                        const LinearGradient(
                          colors: [
                            Color(0xFFFFF7ED),
                            Color(0xFFFEEBD0)
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      _RecordMetricCard(
                        title: 'Water',
                        value:
                        '${record.water} ml',
                        icon: Icons
                            .water_drop_rounded,
                        iconColor:
                        const Color(0xFF0EA5E9),
                        gradient:
                        const LinearGradient(
                          colors: [
                            Color(0xFFE0F2FE),
                            Color(0xFFBAE6FD)
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddEditRecordScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FilledIconCircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _FilledIconCircleButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 18,
          color: Colors.white,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashRadius: 20,
      ),
    );
  }
}

class _RecordMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final LinearGradient gradient;

  const _RecordMetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
