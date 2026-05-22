part of 'admin_dashboard_model.dart';

class NotarySession {
  const NotarySession({
    required this.id,
    required this.documentType,
    required this.notary,
    required this.participants,
    required this.progress,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String documentType;
  final String notary;
  final List<String> participants;
  final int progress;
  final String status;
  final String createdAt;
}
