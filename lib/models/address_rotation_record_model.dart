part of 'admin_dashboard_model.dart';

class AddressRotationRecord {
  AddressRotationRecord({
    required this.id,
    required this.citizenId,
    required this.oldWallet,
    required this.newWallet,
    required this.reason,
    required this.verifiedBy,
    required this.rotationDate,
    required this.status,
  });

  final String id;
  final String citizenId;
  final String oldWallet;
  final String newWallet;
  final String reason;
  final String verifiedBy;
  final String rotationDate;
  String status;
}
