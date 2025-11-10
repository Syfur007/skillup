import 'package:flutter/material.dart';
import 'package:skillup/domain/entities/roadmap.dart';

class RoadmapStepWidget extends StatelessWidget {
  final RoadmapStep step;
  final int stepNumber;

  const RoadmapStepWidget({
    super.key,
    required this.step,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                child: Text(
                  stepNumber.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  step.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '${step.estimatedTime.inHours}h',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          if (step.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(step.description),
            ),
          ],
        ],
      ),
    );
  }
}
