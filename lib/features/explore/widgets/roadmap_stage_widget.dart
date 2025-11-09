import 'package:flutter/material.dart';
import '../models/roadmap.dart';
import 'roadmap_step_widget.dart';

class RoadmapStageWidget extends StatelessWidget {
  final RoadmapStage stage;
  final int stageNumber;

  const RoadmapStageWidget({
    Key? key,
    required this.stage,
    required this.stageNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text('Stage $stageNumber: ${stage.title}'),
        subtitle: Text(
          stage.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stage.steps.length,
            itemBuilder: (context, index) {
              return RoadmapStepWidget(
                step: stage.steps[index],
                stepNumber: index + 1,
              );
            },
          ),
        ],
      ),
    );
  }
}
