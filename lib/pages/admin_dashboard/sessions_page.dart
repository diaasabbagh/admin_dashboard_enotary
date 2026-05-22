part of 'admin_dashboard_page.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key, required this.store});

  final DashboardStore store;

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  String _query = '';
  String _status = 'All';
  String _notary = 'All';

  List<NotarySession> get _filtered {
    return widget.store.sessions.where((session) {
      final text =
          '${session.id} ${session.documentType} ${session.notary} ${session.participants}'
              .toLowerCase();
      return text.contains(_query.toLowerCase()) &&
          (_status == 'All' || session.status == _status) &&
          (_notary == 'All' || session.notary == _notary);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final notaries = ['All', ...widget.store.notaries.map((n) => n.name)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ScopeBanner(
          title: 'Monitoring only',
          text:
              'Admins can search, filter, and inspect sessions. Document content approval and notarization remain with assigned notaries.',
        ),
        const SizedBox(height: 18),
        _Toolbar(
          searchHint: 'Search session, document, participant',
          onSearch: (value) => setState(() => _query = value),
          filters: const [
            'All',
            'Pending',
            'Active',
            'Signed',
            'Notarized',
            'Rejected',
            'Cancelled',
          ],
          selectedFilter: _status,
          onFilter: (value) => setState(() => _status = value),
          secondaryFilters: notaries,
          selectedSecondaryFilter: _notary,
          onSecondaryFilter: (value) => setState(() => _notary = value),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: 'All notarization sessions',
          child: _ResponsiveTable(
            columns: const [
              'Session ID',
              'Document type',
              'Assigned notary',
              'Participants',
              'Progress',
              'Status',
              'Created',
              'Details',
            ],
            rows:
                _filtered.map((session) {
                  return [
                    Text(
                      session.id,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(session.documentType),
                    Text(session.notary),
                    Text(session.participants.join(', ')),
                    _ProgressCell(value: session.progress),
                    _StatusBadge(label: session.status),
                    Text(session.createdAt),
                    IconButton(
                      tooltip: 'View session details',
                      onPressed: () => _showSessionDetails(session),
                      icon: const Icon(Icons.open_in_new_rounded),
                    ),
                  ];
                }).toList(),
          ),
        ),
      ],
    );
  }

  void _showSessionDetails(NotarySession session) {
    showDialog<void>(
      context: context,
      builder:
          (context) => _InfoDialog(
            title: 'Session ${session.id}',
            icon: Icons.fact_check_rounded,
            lines: [
              'Document type: ${session.documentType}',
              'Assigned notary: ${session.notary}',
              'Participants: ${session.participants.join(', ')}',
              'Signing progress: ${session.progress}%',
              'Current status: ${session.status}',
              'Creation date: ${session.createdAt}',
            ],
            note: 'No document content controls are exposed to the admin.',
          ),
    );
  }
}
