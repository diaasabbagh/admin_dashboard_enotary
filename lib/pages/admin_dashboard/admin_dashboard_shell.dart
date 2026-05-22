part of 'admin_dashboard_page.dart';

class AdminDashboardShell extends StatefulWidget {
  const AdminDashboardShell({super.key});

  @override
  State<AdminDashboardShell> createState() => _AdminDashboardShellState();
}

class _AdminDashboardShellState extends State<AdminDashboardShell> {
  final AdminDashboardController _controller = AdminDashboardController();

  AdminSection get _section => _controller.section;
  DashboardStore get _store => _controller.store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _Sidebar(
            selected: _controller.section,
            onSelect:
                (section) => setState(() => _controller.setSection(section)),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/vectorstock_36200520.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(color: AppColors.background.withAlpha(235)),
                ),
                Column(
                  children: [
                    _TopBar(title: _controller.title),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(22),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1420),
                          child: _buildSection(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return switch (_section) {
      AdminSection.dashboard => OverviewPage(store: _store),
      AdminSection.notaries => NotariesPage(
        store: _store,
        onChanged: () => setState(() {}),
      ),
      AdminSection.transactions => SessionsPage(store: _store),
      AdminSection.finalRecords => RecordsPage(store: _store),
      AdminSection.addressRotation => RotationPage(
        store: _store,
        onChanged: () => setState(() {}),
      ),
    };
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selected, required this.onSelect});

  final AdminSection selected;
  final ValueChanged<AdminSection> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      color: AppColors.darkGreen,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.gavel_rounded, color: AppColors.gold, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'E-Notary Admin',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              for (final section in AdminSection.values)
                _SidebarItem(
                  section: section,
                  selected: selected == section,
                  onTap: () => onSelect(section),
                ),
              const Spacer(),
              const _BoundaryPanel(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final AdminSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppColors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(
                  section.icon,
                  color: selected ? AppColors.gold : AppColors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    section.label,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BoundaryPanel extends StatelessWidget {
  const _BoundaryPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white.withAlpha(35)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin scope',
            style: TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Governance only. No document edits, no notary signing, no citizen wallet signing.',
            style: TextStyle(
              color: AppColors.white,
              height: 1.35,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const _StatusPill(
            label: 'Blockchain online',
            tone: StatusTone.success,
            icon: Icons.hub_rounded,
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.green,
            child: Text('AD', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}
