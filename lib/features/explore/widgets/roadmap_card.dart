// roadmap_card.dart
// Small UI component that displays a roadmap summary used in lists/grids.

import 'package:flutter/material.dart';
import 'package:skillup/domain/entities/roadmap.dart';

class RoadmapCard extends StatelessWidget {
  final Roadmap roadmap;
  final VoidCallback onTap;

  const RoadmapCard({super.key, required this.roadmap, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.school),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      roadmap.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                roadmap.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(roadmap.category.name),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
