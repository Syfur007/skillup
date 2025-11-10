import 'package:flutter/material.dart';
import 'package:skillup/domain/entities/roadmap.dart';
import 'package:skillup/domain/entities/module.dart';
import 'package:skillup/core/utils/progress_calculator.dart';
import '../widgets/roadmap_detail_header.dart';
import '../widgets/roadmap_stage_expanded.dart';
import '../../profile/services/firestore_user_service.dart';
import '../services/firestore_module_service.dart';
import 'package:skillup/core/navigation/navigation.dart';
import 'package:skillup/domain/entities/user_roadmap.dart';
import 'package:skillup/features/profile/screens/enrolled_roadmap_screen.dart';

class RoadmapDetailScreen extends StatefulWidget {
  final Roadmap roadmap;

  const RoadmapDetailScreen({super.key, required this.roadmap});

  @override
  State<RoadmapDetailScreen> createState() => _RoadmapDetailScreenState();
}

class _RoadmapDetailScreenState extends State<RoadmapDetailScreen>
    with SingleTickerProviderStateMixin {
  final _userService = FirestoreUserService();
  final _moduleService = FirestoreModuleService();
  late TabController _tabController;
  bool _isLoading = false;
  bool _isInProfile = false;
  UserRoadmap? _userRoadmap;
  double _userProgress = 0.0;
  Map<String, Module> _modules = {};
  bool _loadingModules = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkRoadmapStatus();
    _loadModules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadModules() async {
    setState(() => _loadingModules = true);
    try {
      final modules = <String, Module>{};
      for (final moduleId in widget.roadmap.moduleIds) {
        final module = await _moduleService.getModuleById(moduleId);
        if (module != null) {
          modules[moduleId] = module;
        }
      }
      if (!mounted) return;
      setState(() {
        _modules = modules;
        _loadingModules = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingModules = false);
    }
  }

  Future<void> _checkRoadmapStatus() async {
    // Load the user's roadmap entries to determine enrollment and progress.
    try {
      final list = await _userService.getUserRoadmaps();
      UserRoadmap? found;
      for (final u in list) {
        if (u.roadmapId == widget.roadmap.id) {
          found = u;
          break;
        }
      }
      if (!mounted) return;
      setState(() {
        _userRoadmap = found;
        _isInProfile = found != null;
        _userProgress = found != null ? _normalizeProgress(found) : 0.0;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInProfile = false;
        _userRoadmap = null;
        _userProgress = 0.0;
      });
    }
  }

  double _normalizeProgress(UserRoadmap ur) {
    // Try using stored progress first
    final raw = ur.progress;
    if (raw > 0.0) {
      return ProgressCalculator.normalizeProgress(raw);
    }

    // Fallback: compute from completedSteps
    var total = widget.roadmap.totalTasks;
    if (total <= 0 && _modules.isNotEmpty) {
      // Calculate total from loaded modules
      try {
        total = _modules.values.fold<int>(0, (sum, m) {
          return sum + m.stages.fold<int>(0, (sSum, st) => sSum + st.tasks.length);
        });
      } catch (_) {
        total = 0;
      }
    }
    if (total <= 0) return 0.0;
    final completed = ur.completedSteps.values.where((v) => v == true).length;
    return (completed / total).clamp(0.0, 1.0);
  }

  Future<void> _toggleRoadmap() async {
    setState(() => _isLoading = true);
    try {
      if (_isInProfile) {
        await _userService.removeRoadmap(widget.roadmap.id);
      } else {
        await _userService.addRoadmap(widget.roadmap.id);
      }
      if (mounted) {
        setState(() => _isInProfile = !_isInProfile);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isInProfile
                  ? 'Added to your profile'
                  : 'Removed from your profile',
            ),
          ),
        );
        // Refresh cached userRoadmap and progress
        await _checkRoadmapStatus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roadmap.title),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isInProfile ? Icons.bookmark : Icons.bookmark_border,
              color: _isInProfile ? Colors.amber : null,
            ),
            onPressed: _isLoading ? null : _toggleRoadmap,
            tooltip: _isInProfile ? 'Remove from profile' : 'Add to profile',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'share') {
                _showShareDialog();
              } else if (value == 'report') {
                _showReportDialog();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'share', child: Text('Share')),
              const PopupMenuItem(value: 'report', child: Text('Report')),
            ],
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: RoadmapDetailHeader(
              title: widget.roadmap.title,
              description: widget.roadmap.description,
              imageUrl: widget.roadmap.imageUrl,
              difficulty: widget.roadmap.difficulty,
              estimatedHours: widget.roadmap.estimatedHours,
              averageRating: widget.roadmap.averageRating,
              enrolledCount: widget.roadmap.enrolledCount,
              tags: widget.roadmap.tags,
              progress: _isInProfile ? _userProgress : null,
            ),
          ),
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'OVERVIEW'),
                Tab(text: 'MODULES'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildModulesTab(),
          ],
        ),
      ),
      floatingActionButton: _isInProfile
          ? FloatingActionButton.extended(
              onPressed: () async {
                // Navigate to enrolled roadmap screen with the user's roadmap entry
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EnrolledRoadmapScreen(
                      roadmap: widget.roadmap,
                      userRoadmap: _userRoadmap,
                    ),
                  ),
                );
                // Reload status when returning
                await _checkRoadmapStatus();
              },
              label: const Text('Continue'),
              icon: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Stats Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Roadmap Stats',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox(
                        context,
                        label: 'Modules',
                        value: '${widget.roadmap.totalModules}',
                      ),
                      _buildStatBox(
                        context,
                        label: 'Stages',
                        value: '${widget.roadmap.totalStages}',
                      ),
                      _buildStatBox(
                        context,
                        label: 'Tasks',
                        value: '${widget.roadmap.totalTasks}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category and Creator Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    context,
                    label: 'Category',
                    value: widget.roadmap.category.name,
                    icon: Icons.category,
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    context,
                    label: 'Difficulty',
                    value: widget.roadmap.difficulty.name.toUpperCase(),
                    icon: Icons.trending_up,
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    context,
                    label: 'Duration',
                    value: '${widget.roadmap.estimatedHours} hours',
                    icon: Icons.schedule,
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    context,
                    label: 'Created by',
                    value: widget.roadmap.createdBy,
                    icon: Icons.person,
                  ),
                  if (widget.roadmap.tags.isNotEmpty) ...[
                    const Divider(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tags',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.roadmap.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.2),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description Expansion
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About This Roadmap',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.roadmap.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildModulesTab() {
    if (widget.roadmap.moduleIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.layers_clear,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No modules available yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    // Render simple module placeholders using moduleIds from domain model
    if (_loadingModules) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          ...List.generate(widget.roadmap.moduleIds.length, (index) {
            final moduleId = widget.roadmap.moduleIds[index];
            final module = _modules[moduleId];
            if (module == null) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text('Module ${index + 1}'),
                  subtitle: Text(moduleId),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to module detail screen
                    context.pushPath(RoutePaths.moduleDetailPath(moduleId));
                  },
                ),
              );
            }

            return Column(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(module.title),
                    subtitle: Text(module.description),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.pushPath(RoutePaths.moduleDetailPath(module.id));
                    },
                  ),
                ),

                // Show module stages using RoadmapStageExpanded by mapping ModuleStage -> expected props
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
              ],
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatBox(BuildContext context,
      {required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Roadmap'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share via...'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Roadmap'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Inappropriate Content'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Spam'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Other'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
