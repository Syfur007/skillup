import 'package:flutter/material.dart';
import '../services/firestore_roadmap_service.dart';
import '../models/roadmap.dart';

class CreateRoadmapScreen extends StatefulWidget {
  const CreateRoadmapScreen({super.key});

  @override
  State<CreateRoadmapScreen> createState() => _CreateRoadmapScreenState();
}

class _CreateRoadmapScreenState extends State<CreateRoadmapScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _iconNameCtrl = TextEditingController();
  final _service = FirestoreRoadmapService();
  bool _saving = false;

  final List<_StageData> _stages = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _categoryCtrl.dispose();
    _iconNameCtrl.dispose();
    for (var stage in _stages) {
      stage.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final stages = _stages.map((sd) {
        return RoadmapStage(
          title: sd.titleCtrl.text.trim(),
          description: sd.descCtrl.text.trim(),
          steps: sd.steps.map((stepData) {
            return RoadmapStep(
              name: stepData.nameCtrl.text.trim(),
              description: stepData.descCtrl.text.trim(),
              estimatedTime: Duration(
                minutes: int.tryParse(stepData.timeCtrl.text) ?? 0,
              ),
            );
          }).toList(),
        );
      }).toList();

      await _service.createRoadmap(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        category: _categoryCtrl.text.trim(),
        iconName: _iconNameCtrl.text.trim(),
        stages: stages,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create roadmap: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _addStage() {
    setState(() {
      _stages.add(_StageData());
    });
  }

  void _removeStage(int index) {
    setState(() {
      _stages[index].dispose();
      _stages.removeAt(index);
    });
  }

  void _addStepToStage(int stageIndex) {
    setState(() {
      _stages[stageIndex].steps.add(_StepData());
    });
  }

  void _removeStepFromStage(int stageIndex, int stepIndex) {
    setState(() {
      _stages[stageIndex].steps[stepIndex].dispose();
      _stages[stageIndex].steps.removeAt(stepIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Roadmap'),
        actions: [
          if (_saving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(icon: const Icon(Icons.check), onPressed: _save),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Info Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Title required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _categoryCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Category (e.g., Mobile, Web, Backend)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _iconNameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Icon Name (e.g., flutter, web, code)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stages Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Stages', style: Theme.of(context).textTheme.titleLarge),
                ElevatedButton.icon(
                  onPressed: _addStage,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Stage'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // List of Stages
            ..._stages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              return _buildStageCard(index, stage);
            }),

            if (_stages.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.layers_outlined,
                          size: 48,
                          color: Theme.of(context).disabledColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No stages yet. Add stages to structure your roadmap.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).disabledColor,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard(int stageIndex, _StageData stage) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Stage ${stageIndex + 1}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeStage(stageIndex),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: stage.titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Stage Title',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Stage title required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: stage.descCtrl,
              decoration: const InputDecoration(
                labelText: 'Stage Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Steps within this stage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Steps', style: Theme.of(context).textTheme.titleSmall),
                TextButton.icon(
                  onPressed: () => _addStepToStage(stageIndex),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Step'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...stage.steps.asMap().entries.map((stepEntry) {
              final stepIndex = stepEntry.key;
              final step = stepEntry.value;
              return _buildStepCard(stageIndex, stepIndex, step);
            }),

            if (stage.steps.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No steps in this stage yet.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(int stageIndex, int stepIndex, _StepData step) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Step ${stepIndex + 1}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => _removeStepFromStage(stageIndex, stepIndex),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: step.nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Step Name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Step name required' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: step.descCtrl,
              decoration: const InputDecoration(
                labelText: 'Step Description',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: step.timeCtrl,
              decoration: const InputDecoration(
                labelText: 'Estimated Time (minutes)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

class _StageData {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final List<_StepData> steps = [];

  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    for (var step in steps) {
      step.dispose();
    }
  }
}

class _StepData {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();

  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    timeCtrl.dispose();
  }
}
