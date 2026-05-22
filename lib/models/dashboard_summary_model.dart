part of 'admin_dashboard_model.dart';

class StatInfo {
  const StatInfo(this.label, this.value, this.icon, this.caption);
  final String label;
  final String value;
  final IconData icon;
  final String caption;
}

class ActivityItem {
  const ActivityItem(this.title, this.subtitle, this.time, this.icon);
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
}
