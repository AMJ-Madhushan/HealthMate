import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'features/health_records/providers/health_record_provider.dart';
import 'features/health_records/screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HealthMateApp());
}

class HealthMateApp extends StatelessWidget {
  const HealthMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16A34A);

    final baseTheme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: green,
      brightness: Brightness.light,
    );

    final textTheme = GoogleFonts.poppinsTextTheme(baseTheme.textTheme);

    return ChangeNotifierProvider(
      create: (_) => HealthRecordProvider()..loadRecords(),
      child: MaterialApp(
        title: 'HealthMate',
        debugShowCheckedModeBanner: false,
        theme: baseTheme.copyWith(
          textTheme: textTheme,
          scaffoldBackgroundColor: const Color(0xFFF3F6F4),



          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: green,
            foregroundColor: Colors.white,
            titleTextStyle: textTheme.titleLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),



          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: green,
                width: 1.6,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              textStyle: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: green,
              side: const BorderSide(color: green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              textStyle: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: green,
            foregroundColor: Colors.white,
          ),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
