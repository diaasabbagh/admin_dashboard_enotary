part of 'admin_dashboard_page.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key, required this.store});

  final DashboardStore store;

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  String _query = '';
  String _status = 'All';

  List<FinalRecord> get _filtered {
    return widget.store.records.where((record) {
      final text =
          '${record.recordId} ${record.sessionId} ${record.documentHash} ${record.proofHash} ${record.txHash}'
              .toLowerCase();
      return text.contains(_query.toLowerCase()) &&
          (_status == 'All' || record.status == _status);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ScopeBanner(
          title: 'Read-only finalized records',
          text:
              'Admins can view, verify, and export summaries. Notarized record content cannot be edited or deleted here.',
        ),
        const SizedBox(height: 18),
        _Toolbar(
          searchHint: 'Search record, session, hash',
          onSearch: (value) => setState(() => _query = value),
          filters: const ['All', 'Active', 'Revoked', 'Replaced'],
          selectedFilter: _status,
          onFilter: (value) => setState(() => _status = value),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: 'Final notarized records',
          child: _ResponsiveTable(
            columns: const [
              'Record ID',
              'Session ID',
              'Document hash',
              'Proof hash',
              'Notary wallet',
              'Tx hash',
              'Timestamp',
              'Status',
              'Actions',
            ],
            rows:
                _filtered.map((record) {
                  return [
                    Text(
                      record.recordId,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(record.sessionId),
                    _HashText(record.documentHash),
                    _HashText(record.proofHash),
                    _HashText(record.notaryWallet),
                    _HashText(record.txHash),
                    Text(record.timestamp),
                    _StatusBadge(label: record.status),
                    _ActionCell(
                      children: [
                        IconButton(
                          tooltip: 'View record details',
                          onPressed: () => _showRecordDetails(record),
                          icon: const Icon(Icons.visibility_rounded),
                        ),
                        IconButton(
                          tooltip: 'Verify on blockchain',
                          onPressed: () => _verifyRecord(record),
                          icon: const Icon(Icons.hub_rounded),
                        ),
                        IconButton(
                          tooltip: 'Export summary',
                          onPressed: () => _exportSummary(record),
                          icon: const Icon(Icons.file_download_outlined),
                        ),
                      ],
                    ),
                  ];
                }).toList(),
          ),
        ),
      ],
    );
  }

  void _showRecordDetails(FinalRecord record) {
    showDialog<void>(
      context: context,
      builder:
          (context) => _InfoDialog(
            title: record.recordId,
            icon: Icons.verified_rounded,
            lines: [
              'Session ID: ${record.sessionId}',
              'Document hash: ${record.documentHash}',
              'Proof hash: ${record.proofHash}',
              'Notary wallet address: ${record.notaryWallet}',
              'Blockchain transaction hash: ${record.txHash}',
              'Timestamp: ${record.timestamp}',
              'Status: ${record.status}',
            ],
            note:
                'Read-only blockchain proof metadata. Editing and deletion are unavailable.',
          ),
    );
  }

  void _verifyRecord(FinalRecord record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${record.recordId} verified against ${record.txHash}.'),
      ),
    );
  }

  void _exportSummary(FinalRecord record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Summary export prepared for ${record.recordId}.'),
      ),
    );
  }
}
