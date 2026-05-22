part of 'admin_dashboard_controller.dart';

enum AdminSection {
  dashboard('Dashboard', Icons.dashboard_rounded, 'Admin Overview'),
  notaries('Notaries', Icons.badge_rounded, 'Notary Accounts Management'),
  transactions(
    'Transactions',
    Icons.swap_horiz_rounded,
    'Transactions / Sessions',
  ),
  finalRecords(
    'Final Records',
    Icons.verified_rounded,
    'Final Records / Documents',
  ),
  addressRotation(
    'Address Rotation',
    Icons.sync_lock_rounded,
    'Address Rotation Management',
  );

  const AdminSection(this.label, this.icon, this.title);

  final String label;
  final IconData icon;
  final String title;
}
