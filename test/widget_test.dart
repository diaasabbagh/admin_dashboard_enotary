import 'package:admin_e_notary_dashboard/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('admin dashboard starts on overview', (tester) async {
    await tester.pumpWidget(const AdminENotaryApp());

    expect(find.text('Admin Overview'), findsOneWidget);
    expect(find.text('Total notaries'), findsOneWidget);
    expect(find.byIcon(Icons.gavel_rounded), findsWidgets);
  });
}
