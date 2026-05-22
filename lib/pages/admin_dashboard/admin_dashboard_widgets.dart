part of 'admin_dashboard_page.dart';

class _ScopeBanner extends StatelessWidget {
  const _ScopeBanner({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.admin_panel_settings_rounded,
            color: AppColors.gold,
            size: 30,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(color: AppColors.white, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.searchHint,
    required this.onSearch,
    required this.filters,
    required this.selectedFilter,
    required this.onFilter,
    this.secondaryFilters,
    this.selectedSecondaryFilter,
    this.onSecondaryFilter,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final String searchHint;
  final ValueChanged<String> onSearch;
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilter;
  final List<String>? secondaryFilters;
  final String? selectedSecondaryFilter;
  final ValueChanged<String>? onSecondaryFilter;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 340,
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: searchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ),
        _MenuFilter(
          value: selectedFilter,
          values: filters,
          onChanged: onFilter,
          icon: Icons.filter_alt_rounded,
        ),
        if (secondaryFilters != null &&
            selectedSecondaryFilter != null &&
            onSecondaryFilter != null)
          _MenuFilter(
            value: selectedSecondaryFilter!,
            values: secondaryFilters!,
            onChanged: onSecondaryFilter!,
            icon: Icons.badge_rounded,
          ),
        if (onAction != null && actionLabel != null && actionIcon != null)
          FilledButton.icon(
            onPressed: onAction,
            icon: Icon(actionIcon),
            label: Text(actionLabel!),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }
}

class _MenuFilter extends StatelessWidget {
  const _MenuFilter({
    required this.value,
    required this.values,
    required this.onChanged,
    required this.icon,
  });

  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.green),
          const SizedBox(width: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items:
                  values
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) onChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final StatInfo stat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.green.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(stat.icon, color: AppColors.green),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stat.label,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat.value,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    stat.caption,
                    style: const TextStyle(color: AppColors.gold, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCell extends StatelessWidget {
  const _ActionCell({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: children.length * 48,
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _ResponsiveTable extends StatefulWidget {
  const _ResponsiveTable({required this.columns, required this.rows});

  final List<String> columns;
  final List<List<Widget>> rows;

  @override
  State<_ResponsiveTable> createState() => _ResponsiveTableState();
}

class _ResponsiveTableState extends State<_ResponsiveTable> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: Text('No records match the current filters.')),
      );
    }
    return Scrollbar(
      controller: _horizontalController,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      child: SingleChildScrollView(
        controller: _horizontalController,
        primary: false,
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
          dataTextStyle: const TextStyle(color: AppColors.text),
          columns:
              widget.columns
                  .map((column) => DataColumn(label: Text(column)))
                  .toList(),
          rows:
              widget.rows
                  .map(
                    (row) => DataRow(
                      cells: row.map((cell) => DataCell(cell)).toList(),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity});

  final ActivityItem activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(activity.icon, color: AppColors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  activity.subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            activity.time,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SystemMetric extends StatelessWidget {
  const _SystemMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.muted)),
          ),
          _StatusPill(label: value, tone: tone),
        ],
      ),
    );
  }
}

class _MiniBars extends StatelessWidget {
  const _MiniBars();

  @override
  Widget build(BuildContext context) {
    final values = [0.62, 0.78, 0.45, 0.91, 0.68, 0.84];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Session throughput',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children:
              values.map((value) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      height: 96 * value,
                      decoration: BoxDecoration(
                        color: value > 0.75 ? AppColors.green : AppColors.gold,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

class _ProgressCell extends StatelessWidget {
  const _ProgressCell({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 8,
                backgroundColor: AppColors.border,
                color: AppColors.green,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$value%'),
        ],
      ),
    );
  }
}

class _HashText extends StatelessWidget {
  const _HashText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: value,
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(label);
    return _StatusPill(label: label, tone: tone);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.tone, this.icon});

  final String label;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      StatusTone.success => AppColors.success,
      StatusTone.warning => AppColors.warning,
      StatusTone.danger => AppColors.danger,
      StatusTone.info => AppColors.info,
      StatusTone.neutral => AppColors.neutral,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDialog extends StatelessWidget {
  const _InfoDialog({
    required this.title,
    required this.icon,
    required this.lines,
    required this.note,
  });

  final String title;
  final IconData icon;
  final List<String> lines;
  final String note;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        children: [
          Icon(icon, color: AppColors.green),
          const SizedBox(width: 10),
          Expanded(child: Text(title)),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Text(line),
              ),
            const Divider(),
            Text(
              note,
              style: const TextStyle(color: AppColors.muted, height: 1.35),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required bool destructive,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor:
                    destructive ? AppColors.danger : AppColors.green,
                foregroundColor: AppColors.white,
              ),
              child: Text(confirmLabel),
            ),
          ],
        ),
  );
  return result ?? false;
}

StatusTone _toneFor(String label) {
  return switch (label) {
    'Active' ||
    'Completed' ||
    'Signed' ||
    'Notarized' ||
    'Approved' ||
    'Verified' => StatusTone.success,
    'Pending' || 'Suspended' => StatusTone.warning,
    'Revoked' || 'Rejected' || 'Cancelled' => StatusTone.danger,
    'Replaced' => StatusTone.info,
    _ => StatusTone.neutral,
  };
}

enum StatusTone { success, warning, danger, info, neutral }
