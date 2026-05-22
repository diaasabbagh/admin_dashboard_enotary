part of 'admin_dashboard_page.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key, required this.store});

  final DashboardStore store;

  @override
  Widget build(BuildContext context) {
    final stats = [
      StatInfo(
        'Total notaries',
        store.notaries.length.toString(),
        Icons.badge_rounded,
        '+4 this month',
      ),
      StatInfo(
        'Active notaries',
        store.notaries.where((n) => n.status == 'Active').length.toString(),
        Icons.verified_user_rounded,
        'licensed accounts',
      ),
      StatInfo(
        'Total citizens',
        '18,420',
        Icons.groups_rounded,
        '+312 this week',
      ),
      StatInfo(
        'Total sessions',
        store.sessions.length.toString(),
        Icons.fact_check_rounded,
        'all notarization sessions',
      ),
      StatInfo(
        'Completed notarizations',
        store.records.where((r) => r.status == 'Active').length.toString(),
        Icons.task_alt_rounded,
        'finalized records',
      ),
      StatInfo(
        'Revoked records',
        store.records.where((r) => r.status == 'Revoked').length.toString(),
        Icons.block_rounded,
        'read-only history',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ScopeBanner(
          title: 'Platform manager workspace',
          text:
              'This dashboard controls accounts, monitoring, record verification, and assisted wallet rotation. Legal signing remains with notaries and citizens.',
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final columns =
                width > 1180
                    ? 3
                    : width > 760
                    ? 2
                    : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: width > 760 ? 2.55 : 3.7,
              ),
              itemCount: stats.length,
              itemBuilder: (context, index) => _StatCard(stat: stats[index]),
            );
          },
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 1000;
            final activity = _SectionCard(
              title: 'Recent platform activities',
              child: Column(
                children:
                    store.activities
                        .map((activity) => _ActivityRow(activity: activity))
                        .toList(),
              ),
            );
            final status = _SectionCard(
              title: 'System / blockchain status',
              child: const Column(
                children: [
                  _SystemMetric(
                    label: 'RPC node',
                    value: 'Healthy',
                    tone: StatusTone.success,
                  ),
                  _SystemMetric(
                    label: 'Network',
                    value: 'Consortium chain',
                    tone: StatusTone.info,
                  ),
                  _SystemMetric(
                    label: 'Latest block',
                    value: '# 9,842,112',
                    tone: StatusTone.neutral,
                  ),
                  _SystemMetric(
                    label: 'Proof queue',
                    value: '3 pending writes',
                    tone: StatusTone.warning,
                  ),
                  SizedBox(height: 14),
                  _MiniBars(),
                ],
              ),
            );
            if (!wide) {
              return Column(
                children: [activity, const SizedBox(height: 18), status],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: activity),
                const SizedBox(width: 18),
                Expanded(flex: 2, child: status),
              ],
            );
          },
        ),
      ],
    );
  }
}
