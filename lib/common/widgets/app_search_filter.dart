import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/app_colors.dart';

/// Reusable dark search bar used across Shows, Podcasts, Presenters screens
class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0C1728) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? const Color(0xFF162742) : const Color(0xFFE2E8F0),
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: GoogleFonts.inter(
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(
                  color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                  size: 18,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0C1728) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? const Color(0xFF162742) : const Color(0xFFE2E8F0),
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Icon(
              Icons.tune_rounded,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}

/// Horizontal scrollable filter chip row used across Shows, Podcasts, Presenters, Charts
class AppFilterChips extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onChanged;
  const AppFilterChips({
    super.key,
    required this.filters,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = filters[i];
          final isSelected = f == selected;
          return GestureDetector(
            onTap: () => onChanged(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE24600) : const Color(0xFF0B1528),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? const Color(0xFFE24600) : const Color(0xFF1E3A8A).withValues(alpha: 0.6),
                ),
              ),
              child: Text(
                f,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
