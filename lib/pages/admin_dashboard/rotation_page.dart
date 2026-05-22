part of 'admin_dashboard_page.dart';

class RotationPage extends StatefulWidget {
  const RotationPage({super.key, required this.store, required this.onChanged});

  final DashboardStore store;
  final VoidCallback onChanged;

  @override
  State<RotationPage> createState() => _RotationPageState();
}

class _RotationPageState extends State<RotationPage> {
  String _query = '';
  String _status = 'All';

  List<AddressRotationRecord> get _filtered {
    return widget.store.rotations.where((rotation) {
      final text =
          '${rotation.id} ${rotation.citizenId} ${rotation.oldWallet} ${rotation.newWallet} ${rotation.reason}'
              .toLowerCase();
      return text.contains(_query.toLowerCase()) &&
          (_status == 'All' || rotation.status == _status);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ScopeBanner(
          title: 'Admin wallet rotation process',
          text:
              'Admins rotate a citizen wallet after identity verification. Old wallets become inactive for future signatures, while earlier signatures remain valid for their signing time.',
        ),
        const SizedBox(height: 18),
        _Toolbar(
          searchHint: 'Search rotation, citizen, wallet',
          onSearch: (value) => setState(() => _query = value),
          filters: const ['All', 'Completed', 'Cancelled'],
          selectedFilter: _status,
          onFilter: (value) => setState(() => _status = value),
          actionLabel: 'Rotate wallet',
          actionIcon: Icons.sync_lock_rounded,
          onAction: _showCreateRotationDialog,
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: 'Wallet rotations',
          child: _ResponsiveTable(
            columns: const [
              'Rotation ID',
              'Citizen ID',
              'Old wallet',
              'New wallet',
              'Reason',
              'Verified by',
              'Rotation date',
              'Status',
              'Actions',
            ],
            rows:
                _filtered.map((rotation) {
                  return [
                    Text(
                      rotation.id,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(rotation.citizenId),
                    _HashText(rotation.oldWallet),
                    _HashText(rotation.newWallet),
                    Text(rotation.reason),
                    Text(rotation.verifiedBy),
                    Text(rotation.rotationDate),
                    _StatusBadge(label: rotation.status),
                    _ActionCell(
                      children: [
                        IconButton(
                          tooltip: 'View rotation details',
                          onPressed: () => _showRotationDetails(rotation),
                          icon: const Icon(Icons.visibility_rounded),
                        ),
                        IconButton(
                          tooltip: 'Cancel rotation record',
                          onPressed:
                              rotation.status == 'Completed'
                                  ? () => _confirmCancel(rotation)
                                  : null,
                          icon: const Icon(Icons.cancel_rounded),
                        ),
                        IconButton(
                          tooltip: 'View wallet history',
                          onPressed: () => _showWalletHistory(rotation),
                          icon: const Icon(Icons.history_rounded),
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

  Future<void> _showCreateRotationDialog() async {
    final controller = AdminDashboardController(store: widget.store);
    final rotation = await showDialog<AddressRotationRecord>(
      context: context,
      builder:
          (context) => _AddressRotationFormDialog(
            rotationId: controller.addressRotation.nextRotationId(),
          ),
    );
    if (rotation == null) return;

    setState(() => controller.addressRotation.addRotation(rotation));
    widget.onChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wallet rotated for ${rotation.citizenId}.')),
    );
  }

  Future<void> _confirmCancel(AddressRotationRecord rotation) async {
    final confirmed = await _confirm(
      context,
      title: 'Cancel rotation record?',
      message:
          'This marks ${rotation.id} as cancelled in the admin dashboard history.',
      confirmLabel: 'Cancel record',
      destructive: true,
    );
    if (confirmed) {
      setState(
        () => AdminDashboardController(
          store: widget.store,
        ).addressRotation.cancelRotation(rotation),
      );
      widget.onChanged();
    }
  }

  void _showRotationDetails(AddressRotationRecord rotation) {
    showDialog<void>(
      context: context,
      builder:
          (context) => _InfoDialog(
            title: rotation.id,
            icon: Icons.sync_lock_rounded,
            lines: [
              'Citizen ID: ${rotation.citizenId}',
              'Old wallet address: ${rotation.oldWallet}',
              'New wallet address: ${rotation.newWallet}',
              'Reason: ${rotation.reason}',
              'Verified by: ${rotation.verifiedBy}',
              'Rotation date: ${rotation.rotationDate}',
              'Status: ${rotation.status}',
            ],
            note:
                'Previous signatures remain valid because the old wallet was valid at signing time.',
          ),
    );
  }

  void _showWalletHistory(AddressRotationRecord rotation) {
    showDialog<void>(
      context: context,
      builder:
          (context) => _InfoDialog(
            title: 'Wallet history for ${rotation.citizenId}',
            icon: Icons.history_rounded,
            lines: [
              'Identity: ${rotation.citizenId}',
              'Inactive wallet: ${rotation.oldWallet}',
              'Active wallet: ${rotation.newWallet}',
              'Rotation performed by: ${rotation.verifiedBy}',
              'Past signatures: valid by historical wallet state',
              'Future signatures: must use active wallet',
            ],
            note: 'Identity continuity is preserved across wallet rotation.',
          ),
    );
  }
}

class _AddressRotationFormDialog extends StatefulWidget {
  const _AddressRotationFormDialog({required this.rotationId});

  final String rotationId;

  @override
  State<_AddressRotationFormDialog> createState() =>
      _AddressRotationFormDialogState();
}

class _AddressRotationFormDialogState
    extends State<_AddressRotationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _citizenController = TextEditingController();
  final _oldWalletController = TextEditingController();
  final _newWalletController = TextEditingController();
  final _reasonController = TextEditingController();
  final _verifiedByController = TextEditingController(text: 'Admin AD');
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateController = TextEditingController(
      text:
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _citizenController.dispose();
    _oldWalletController.dispose();
    _newWalletController.dispose();
    _reasonController.dispose();
    _verifiedByController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Row(
        children: [
          Icon(Icons.sync_lock_rounded, color: AppColors.green),
          SizedBox(width: 10),
          Expanded(child: Text('Rotate citizen wallet')),
        ],
      ),
      content: SizedBox(
        width: 580,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _RotationTextField(
                  controller: _citizenController,
                  label: 'Citizen ID',
                  icon: Icons.person_search_rounded,
                ),
                const SizedBox(height: 12),
                _RotationTextField(
                  controller: _oldWalletController,
                  label: 'Old wallet address',
                  icon: Icons.account_balance_wallet_rounded,
                ),
                const SizedBox(height: 12),
                _RotationTextField(
                  controller: _newWalletController,
                  label: 'New wallet address',
                  icon: Icons.wallet_rounded,
                ),
                const SizedBox(height: 12),
                _RotationTextField(
                  controller: _reasonController,
                  label: 'Reason',
                  icon: Icons.notes_rounded,
                ),
                const SizedBox(height: 12),
                _RotationTextField(
                  controller: _verifiedByController,
                  label: 'Verified by',
                  icon: Icons.admin_panel_settings_rounded,
                ),
                const SizedBox(height: 12),
                _RotationTextField(
                  controller: _dateController,
                  label: 'Rotation date',
                  hintText: 'YYYY-MM-DD',
                  icon: Icons.event_rounded,
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
          icon: const Icon(Icons.sync_lock_rounded),
          label: const Text('Complete rotation'),
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
      AddressRotationRecord(
        id: widget.rotationId,
        citizenId: _citizenController.text.trim(),
        oldWallet: _oldWalletController.text.trim(),
        newWallet: _newWalletController.text.trim(),
        reason: _reasonController.text.trim(),
        verifiedBy: _verifiedByController.text.trim(),
        rotationDate: _dateController.text.trim(),
        status: 'Completed',
      ),
    );
  }
}

class _RotationTextField extends StatelessWidget {
  const _RotationTextField({
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
