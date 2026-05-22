import 'package:flutter/material.dart';

import '../models/admin_dashboard_model.dart';

part 'admin_section.dart';
part 'notary_accounts_controller.dart';
part 'address_rotation_controller.dart';

class AdminDashboardController {
  AdminDashboardController({DashboardStore? store})
    : this._(store ?? DashboardStore.seeded());

  AdminDashboardController._(this.store)
    : notaryAccounts = NotaryAccountsController(store: store),
      addressRotation = AddressRotationController(store: store);

  final DashboardStore store;
  final NotaryAccountsController notaryAccounts;
  final AddressRotationController addressRotation;
  AdminSection section = AdminSection.dashboard;

  String get title => section.title;

  void setSection(AdminSection nextSection) {
    section = nextSection;
  }
}
