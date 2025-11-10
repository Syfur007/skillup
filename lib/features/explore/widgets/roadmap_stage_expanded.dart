import 'package:flutter/material.dart';

class RoadmapStageExpanded extends StatefulWidget {
  final String stageTitle;
  final String? stageDescription;
  final int taskCount;
  final int resourceCount;
  final int estimatedMinutes;
  final bool isOptional;
  final List<Map<String, dynamic>> tasks;

  const RoadmapStageExpanded({
    super.key,
    required this.stageTitle,
    this.stageDescription,
    required this.taskCount,
    required this.resourceCount,
    required this.estimatedMinutes,
    required this.isOptional,
    this.tasks = const [],
  });

  @override
  State<RoadmapStageExpanded> createState() => _RoadmapStageExpandedState();
}

class _RoadmapStageExpandedState extends State<RoadmapStageExpanded> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stageTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (widget.stageDescription != null &&
                            widget.stageDescription!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              widget.stageDescription!,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.isOptional)
                    Chip(
                      label: const Text('Optional', style: TextStyle(fontSize: 11)),
                      backgroundColor: Colors.orange.withValues(alpha: 0.2),
                      labelStyle: const TextStyle(color: Colors.orange),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Column(
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Metrics
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetric(
                            icon: Icons.checklist,
                            label: '${widget.taskCount} tasks',
                            context: context,
                          ),
                          _buildMetric(
                            icon: Icons.library_books,
                            label: '${widget.resourceCount} resources',
                            context: context,
                          ),
                          _buildMetric(
                            icon: Icons.schedule,
                            label: '${widget.estimatedMinutes} min',
                            context: context,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tasks List
                      if (widget.tasks.isNotEmpty) ...[
                        Text(
                          'Tasks',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ...widget.tasks.map((task) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  _getTaskTypeIcon(task['type'] ?? 'other'),
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task['title'] ?? '',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      if ((task['description'] ?? '').isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            task['description'] ?? '',
                                            style: Theme.of(context).textTheme.bodySmall,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (task['points'] != null && task['points'] > 0)
                                  Chip(
                                    label: Text(
                                      '+${task['points']} pts',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    backgroundColor: Colors.green.withValues(alpha: 0.2),
                                    labelStyle: const TextStyle(color: Colors.green),
                                    visualDensity: VisualDensity.compact,
                                  ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  IconData _getTaskTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'reading':
        return Icons.description;
      case 'watching':
        return Icons.play_circle;
      case 'practice':
        return Icons.code;
      case 'project':
        return Icons.build;
      case 'research':
        return Icons.search;
      case 'discussion':
        return Icons.chat;
      default:
        return Icons.task;
    }
  }
}

