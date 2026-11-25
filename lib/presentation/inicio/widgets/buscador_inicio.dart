import 'package:flutter/material.dart';
import 'package:libreria/core/theme/app_theme.dart';

class BuscadorInicio extends StatelessWidget {
  final VoidCallback onTap;
  const BuscadorInicio({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.parchmentDeep,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.brass.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.leather),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Buscar en el catálogo...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.leather.withValues(alpha: 0.55),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
