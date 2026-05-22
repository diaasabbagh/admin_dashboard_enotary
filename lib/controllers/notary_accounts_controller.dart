part of 'admin_dashboard_controller.dart';

class NotaryAccountsController {
  NotaryAccountsController({required this.store});

  final DashboardStore store;

  void addNotary(NotaryAccount account) {
    store.notaries.add(account);
  }

  void updateNotary(NotaryAccount notary, NotaryAccount updated) {
    notary
      ..name = updated.name
      ..licenseId = updated.licenseId
      ..jurisdiction = updated.jurisdiction
      ..expiryDate = updated.expiryDate
      ..wallet = updated.wallet
      ..status = updated.status;
  }

  void changeStatus(NotaryAccount notary, String status) {
    notary.status = status;
  }
}
