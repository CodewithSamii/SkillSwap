import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/skill_listing.dart';
import '../../../widgets/skill_card.dart';
import '../widgets/skill_detail_sheet.dart';

class ExploreTab extends StatefulWidget {
  final List<SkillListing>? externalListings;

  const ExploreTab({super.key, this.externalListings});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  late List<SkillListing> _listings;

  final List<String> _categories = const [
    'All',
    'Tech',
    'Language',
    'Design',
    'Media',
    'Music',
  ];

  @override
  void initState() {
    super.initState();
    _listings = widget.externalListings ?? List.from(SkillListing.sampleListings);
  }

  @override
  void didUpdateWidget(covariant ExploreTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.externalListings != null) {
      _listings = widget.externalListings!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SkillListing> get _filteredListings {
    final query = _searchController.text.toLowerCase().trim();
    return _listings.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.teachingSkill.toLowerCase().contains(query) ||
          item.wantingSkill.toLowerCase().contains(query) ||
          item.instructorName.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _openDetailSheet(SkillListing listing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SkillDetailSheet(
        listing: listing,
        onProposalSent: () {
          // Handled in sheet
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredListings;

    return Column(
      children: [
        // Search & Filter Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 12),
          child: Column(
            children: [
              // Search Field
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search skills (e.g. Flutter, French, UI/UX)...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  fillColor: AppColors.background,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Filter Chips (SingleChildScrollView with horizontal axis)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        backgroundColor: AppColors.background,
                        selectedColor: AppColors.primary,
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // List of Listings
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'No skill exchanges found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Try adjusting your search keywords or filter category.',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
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
                    return SkillCard(
                      listing: item,
                      onTap: () => _openDetailSheet(item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

