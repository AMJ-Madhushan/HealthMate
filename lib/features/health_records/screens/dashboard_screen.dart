import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/health_record_provider.dart';
import 'record_list_screen.dart';
import 'add_edit_record_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthRecordProvider>(context);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final totalWater = provider.totalWaterForDate(today);
    final totalSteps = provider.totalStepsForDate(today);
    final totalCalories = provider.totalCaloriesForDate(today);

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 72,
        titleSpacing: 16,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: const AssetImage('assets/images/profile.png'),
              backgroundColor: Colors.transparent,
            ),

            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello Janitha,',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  'Welcome to HealthMate',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_active_rounded,
                  size: 22,
                  color: Colors.white,
                ),
                onPressed: () {
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Daily Health Overview',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE4F5EA),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: Color(0xFF16A34A),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          today,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Today\'s Summary',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _StatCard(
                title: 'Steps',
                subtitle: 'Walked',
                value: totalSteps.toString(),
                icon: Icons.directions_walk_rounded,
                iconColor: const Color(0xFF16A34A),
                gradient: const LinearGradient(
                  colors: [Color(0xFFDCFCE7), Color(0xFFBBF7D0)],
                ),
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'Calories',
                subtitle: 'Burned',
                value: totalCalories.toString(),
                icon: Icons.local_fire_department_rounded,
                iconColor: const Color(0xFFF97316),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF7ED), Color(0xFFFEEBD0)],
                ),
              ),
              const SizedBox(height: 12),
              _StatCard(
                title: 'Water',
                subtitle: 'Intake (ml)',
                value: totalWater.toString(),
                icon: Icons.water_drop_rounded,
                iconColor: const Color(0xFF0EA5E9),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RecordListScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list_rounded),
                  label: const Text('View Health Records'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddEditRecordScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add New Record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final Color iconColor;
  final LinearGradient gradient;

  const _StatCard({
    required this.title,
    required this.subtitle,
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
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
