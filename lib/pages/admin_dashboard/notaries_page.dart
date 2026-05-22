part of 'admin_dashboard_page.dart';

class NotariesPage extends StatefulWidget {
  const NotariesPage({super.key, required this.store, required this.onChanged});

  final DashboardStore store;
  final VoidCallback onChanged;

  @override
  State<NotariesPage> createState() => _NotariesPageState();
}

class _NotariesPageState extends State<NotariesPage> {
  String _query = '';
  String _status = 'All';

  List<NotaryAccount> get _filtered {
    return widget.store.notaries.where((notary) {
      final haystack =
          '${notary.name} ${notary.licenseId} ${notary.jurisdiction} ${notary.wallet}'
              .toLowerCase();
      final matchesQuery = haystack.contains(_query.toLowerCase());
      final matchesStatus = _status == 'All' || notary.status == _status;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ScopeBanner(
          title: 'Admin governance actions',
          text:
              'Admins may create, update, activate, suspend, or revoke notary accounts. They cannot sign or notarize documents for a notary.',
        ),
        const SizedBox(height: 18),
        _Toolbar(
          searchHint: 'Search notary, license, wallet',
          onSearch: (value) => setState(() => _query = value),
          filters: ['All', 'Active', 'Suspended', 'Revoked'],
          selectedFilter: _status,
          onFilter: (value) => setState(() => _status = value),
          actionLabel: 'Add notary',
          actionIcon: Icons.add_rounded,
          onAction: _showAddNotaryDialog,
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: 'Notary accounts',
          child: _ResponsiveTable(
            columns: const [
              'Full name',
              'License ID',
              'Jurisdiction',
              'Expiry',
              'Wallet',
              'Status',
              'Actions',
            ],
            rows:
                _filtered.map((notary) {
                  return [
                    Text(
                      notary.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(notary.licenseId),
                    Text(notary.jurisdiction),
                    Text(notary.expiryDate),
                    _HashText(notary.wallet),
                    _StatusBadge(label: notary.status),
                    _ActionCell(
                      children: [
                        IconButton(
                          tooltip: 'View details',
                          onPressed: () => _showNotaryDetails(notary),
                          icon: const Icon(Icons.visibility_rounded),
                        ),
                        IconButton(
                          tooltip: 'Edit notary',
                          onPressed: () => _showEditNotaryDialog(notary),
                          icon: const Icon(Icons.edit_rounded),
                        ),
                        IconButton(
                          tooltip: 'Activate notary',
                          onPressed:
                              notary.status == 'Active'
                                  ? null
                                  : () => _changeNotaryStatus(notary, 'Active'),
                          icon: const Icon(Icons.check_circle_rounded),
                        ),
                        IconButton(
                          tooltip: 'Suspend notary',
                          onPressed:
                              notary.status == 'Suspended'
                                  ? null
                                  : () =>
                                      _confirmNotaryStatus(notary, 'Suspended'),
                          icon: const Icon(Icons.pause_circle_rounded),
                        ),
                        IconButton(
                          tooltip: 'Revoke notary account',
                          onPressed:
                              notary.status == 'Revoked'
                                  ? null
                                  : () =>
                                      _confirmNotaryStatus(notary, 'Revoked'),
                          icon: const Icon(Icons.block_rounded),
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

  Future<void> _showAddNotaryDialog() async {
    final account = await showDialog<NotaryAccount>(
      context: context,
      builder: (context) => const _NotaryFormDialog(),
    );
    if (account == null) return;

    setState(
      () => AdminDashboardController(
        store: widget.store,
      ).notaryAccounts.addNotary(account),
    );
    widget.onChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${account.name} added to notary accounts.')),
    );
  }

  Future<void> _showEditNotaryDialog(NotaryAccount notary) async {
    final updated = await showDialog<NotaryAccount>(
      context: context,
      builder: (context) => _NotaryFormDialog(notary: notary),
    );
    if (updated == null) return;

    setState(
      () => AdminDashboardController(
        store: widget.store,
      ).notaryAccounts.updateNotary(notary, updated),
    );
    widget.onChanged();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${updated.name} updated.')));
  }

  void _showNotaryDetails(NotaryAccount notary) {
    showDialog<void>(
      context: context,
      builder:
          (context) => _InfoDialog(
            title: notary.name,
            icon: Icons.badge_rounded,
            lines: [
              'License ID: ${notary.licenseId}',
              'Jurisdiction: ${notary.jurisdiction}',
              'License expiry date: ${notary.expiryDate}',
              'Wallet address: ${notary.wallet}',
              'Status: ${notary.status}',
            ],
            note:
                'Admin view only. Notary legal actions are intentionally absent.',
          ),
    );
  }

  Future<void> _confirmNotaryStatus(NotaryAccount notary, String status) async {
    final confirmed = await _confirm(
      context,
      title: '$status notary account?',
      message:
          'This changes account access for ${notary.name}. It does not change existing notarized records.',
      confirmLabel: status,
      destructive: status != 'Active',
    );
    if (confirmed) {
      _changeNotaryStatus(notary, status);
    }
  }

  void _changeNotaryStatus(NotaryAccount notary, String status) {
    setState(
      () => AdminDashboardController(
        store: widget.store,
      ).notaryAccounts.changeStatus(notary, status),
    );
    widget.onChanged();
  }
}

class _NotaryFormDialog extends StatefulWidget {
  const _NotaryFormDialog({this.notary});

  final NotaryAccount? notary;

  @override
  State<_NotaryFormDialog> createState() => _NotaryFormDialogState();
}

class _NotaryFormDialogState extends State<_NotaryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _licenseController;
  late final TextEditingController _jurisdictionController;
  late final TextEditingController _expiryController;
  late final TextEditingController _walletController;
  late String _status;

  bool get _isEditing => widget.notary != null;

  @override
  void initState() {
    super.initState();
    final notary = widget.notary;
    _nameController = TextEditingController(text: notary?.name ?? '');
    _licenseController = TextEditingController(text: notary?.licenseId ?? '');
    _jurisdictionController = TextEditingController(
      text: notary?.jurisdiction ?? '',
    );
    _expiryController = TextEditingController(text: notary?.expiryDate ?? '');
    _walletController = TextEditingController(text: notary?.wallet ?? '');
    _status = notary?.status ?? 'Active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _jurisdictionController.dispose();
    _expiryController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        children: [
          Icon(
            _isEditing ? Icons.edit_rounded : Icons.add_rounded,
            color: AppColors.green,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(_isEditing ? 'Edit notary' : 'Add notary')),
        ],
      ),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NotaryTextField(
                  controller: _nameController,
                  label: 'Full name',
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 12),
                _NotaryTextField(
                  controller: _licenseController,
                  label: 'License ID',
                  icon: Icons.badge_rounded,
                ),
                const SizedBox(height: 12),
                _NotaryTextField(
                  controller: _jurisdictionController,
                  label: 'Jurisdiction',
                  icon: Icons.location_city_rounded,
                ),
                const SizedBox(height: 12),
                _NotaryTextField(
                  controller: _expiryController,
                  label: 'License expiry date',
                  hintText: 'YYYY-MM-DD',
                  icon: Icons.event_rounded,
                ),
                const SizedBox(height: 12),
                _NotaryTextField(
                  controller: _walletController,
                  label: 'Wallet address',
                  icon: Icons.account_balance_wallet_rounded,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.verified_user_rounded),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(
                      value: 'Suspended',
                      child: Text('Suspended'),
                    ),
                    DropdownMenuItem(value: 'Revoked', child: Text('Revoked')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _status = value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: Icon(_isEditing ? Icons.save_rounded : Icons.add_rounded),
          label: Text(_isEditing ? 'Save changes' : 'Add notary'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.white,
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      NotaryAccount(
        name: _nameController.text.trim(),
        licenseId: _licenseController.text.trim(),
        jurisdiction: _jurisdictionController.text.trim(),
        expiryDate: _expiryController.text.trim(),
        wallet: _walletController.text.trim(),
        status: _status,
      ),
    );
  }
}

class _NotaryTextField extends StatelessWidget {
  const _NotaryTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hintText,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}
