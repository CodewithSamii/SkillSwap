import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/swap_activity.dart';
import '../../../widgets/activity_card.dart';

class ActivityTab extends StatefulWidget {
  final List<SwapActivity>? externalActivities;
  final void Function(String id)? onToggleStatus;

  const ActivityTab({
    super.key,
    this.externalActivities,
    this.onToggleStatus,
  });

  @override
  State<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  String _filter = 'All';
  late List<SwapActivity> _activities;

  @override
  void initState() {
    super.initState();
    _activities = widget.externalActivities ?? List.from(SwapActivity.sampleActivities);
  }

  @override
  void didUpdateWidget(covariant ActivityTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.externalActivities != null) {
      _activities = widget.externalActivities!;
    }
  }

  List<SwapActivity> get _filteredActivities {
    if (_filter == 'All') return _activities;
    return _activities.where((a) {
      if (_filter == 'Completed') return a.isCompleted;
      return a.status.toLowerCase() == _filter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredActivities;

    return Column(
      children: [
        // Filter Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: ['All', 'Active', 'Scheduled', 'Completed'].map((tab) {
                final isSelected = _filter == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      tab,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _filter = tab;
                      });
                    },
                    backgroundColor: AppColors.background,
                    selectedColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Activity List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.event_busy_rounded, size: 48, color: AppColors.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'No sessions in this filter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Check "All" or explore other skill exchanges to start swapping.',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, index) {
                    final item = filtered[index];
                    return ActivityCard(
                      activity: item,
                      onStatusToggled: () {
                        setState(() {});
                        widget.onToggleStatus?.call(item.id);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

