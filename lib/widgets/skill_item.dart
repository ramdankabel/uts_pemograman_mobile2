import 'package:flutter/material.dart';
import '../models/profile.dart';

/// Baris skill dengan bar tingkat penguasaan.
class SkillItem extends StatelessWidget {
  final Skill skill;

  const SkillItem({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skill.nama,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${(skill.level * 100).round()}%',
                  style: TextStyle(color: cs.secondary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: skill.level,
              minHeight: 8,
              backgroundColor: cs.primary.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(cs.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
