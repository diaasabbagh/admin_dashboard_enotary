import 'package:flutter/material.dart';

import 'constant/colors.dart';
import 'pages/admin_dashboard/admin_dashboard_page.dart';

void main() {
  runApp(const AdminENotaryApp());
}

class AdminENotaryApp extends StatelessWidget {
  const AdminENotaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Notary Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          primary: AppColors.green,
          secondary: AppColors.gold,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Arial',
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        dataTableTheme: const DataTableThemeData(
          headingRowColor: WidgetStatePropertyAll(AppColors.tableHeader),
          dividerThickness: 0.7,
        ),
      ),
      home: const AdminDashboardShell(),
    );
  }
}
