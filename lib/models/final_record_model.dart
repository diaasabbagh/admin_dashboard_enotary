part of 'admin_dashboard_model.dart';

class FinalRecord {
  const FinalRecord({
    required this.recordId,
    required this.sessionId,
    required this.documentHash,
    required this.proofHash,
    required this.notaryWallet,
    required this.txHash,
    required this.timestamp,
    required this.status,
  });

  final String recordId;
  final String sessionId;
  final String documentHash;
  final String proofHash;
  final String notaryWallet;
  final String txHash;
  final String timestamp;
  final String status;
}
