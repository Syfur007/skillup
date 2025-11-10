import 'package:flutter/material.dart';
import 'package:skillup/domain/entities/module.dart';
import 'package:skillup/features/explore/services/firestore_module_service.dart';
import 'package:skillup/features/explore/widgets/roadmap_stage_expanded.dart';

class ModuleScreen extends StatefulWidget {
  final String moduleId;

  const ModuleScreen({super.key, required this.moduleId});

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  final _moduleService = FirestoreModuleService();
  Module? _module;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadModule();
  }

  Future<void> _loadModule() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final module = await _moduleService.getModuleById(widget.moduleId);
      if (!mounted) return;
      setState(() {
        _module = module;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load module';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Module')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Module')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadModule,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_module == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Module')),
        body: Center(child: Text('Module not found: ${widget.moduleId}')),
      );
    }

    final module = _module!;

    final totalTasks = module.stages.fold<int>(0, (prev, s) => prev + s.tasks.length);
    final totalResources = module.stages.fold<int>(0, (prev, s) => prev + s.resources.length);

    return Scaffold(
      appBar: AppBar(
        title: Text(module.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      if (module.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            module.imageUrl!,
                            width: 96,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: 96,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(Icons.school, color: Theme.of(context).primaryColor),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(module.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(module.description, style: Theme.of(context).textTheme.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _smallStat(context, Icons.layers, '${module.totalStages} stages'),
                                const SizedBox(width: 8),
                                _smallStat(context, Icons.task, '$totalTasks tasks'),
                                const SizedBox(width: 8),
                                _smallStat(context, Icons.book, '$totalResources resources'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Stages
            ...module.stages.map((s) {
              return RoadmapStageExpanded(
                stageTitle: s.title,
                stageDescription: s.description,
                taskCount: s.tasks.length,
                resourceCount: s.resources.length,
                estimatedMinutes: s.estimatedMinutes,
                isOptional: s.isOptional,
                tasks: s.tasks.map((t) => {
                      'title': t.title,
                      'description': t.description,
                      'type': t.taskType,
                      'points': t.points,
                    }).toList(),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _smallStat(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).primaryColor),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
