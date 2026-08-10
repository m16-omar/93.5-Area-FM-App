import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/app_colors.dart';

/// Reusable dark search bar used across Shows, Podcasts, Presenters screens
class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const AppSearchBar({super.key, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: TextField(
              controller: controller,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(color: AppColors.textMutedDark, fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMutedDark, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.navyBlue,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.royalBlue),
          ),
          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderDark,
                ),
              ),
              child: Text(
                f,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
