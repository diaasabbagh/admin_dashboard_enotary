part of 'admin_dashboard_model.dart';

class NotaryAccount {
  NotaryAccount({
    required this.name,
    required this.licenseId,
    required this.jurisdiction,
    required this.expiryDate,
    required this.wallet,
    required this.status,
  });

  String name;
  String licenseId;
  String jurisdiction;
  String expiryDate;
  String wallet;
  String status;
}
