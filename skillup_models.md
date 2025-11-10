# SkillUp Roadmapping Tool - Entity Models Reference

## 1. User Entity

**Purpose**: Represents a user account with profile information, preferences, and activity tracking.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique user identifier |
| email | String | Yes | User's email address |
| username | String | Yes | Unique username |
| displayName | String | No | Display name for UI |
| bio | String | No | User biography/description |
| profilePictureUrl | String | No | URL to profile picture |
| interests | List<String> | Yes | List of user interests/goals |
| createdAt | DateTime | Yes | Account creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |
| onboardingCompleted | Boolean | Yes | Has user completed onboarding |
| authProvider | Enum (AuthProvider) | Yes | Authentication method used |
| preferences | UserPreferences | Yes | User preferences object |
| activeRoadmapIds | List<String> | Yes | IDs of roadmaps in progress |
| completedRoadmapIds | List<String> | Yes | IDs of completed roadmaps |
| groupIds | List<String> | Yes | IDs of groups user belongs to |
| achievements | List<Achievement> | Yes | Earned achievements |
| totalPoints | Integer | Yes | Total gamification points |

### AuthProvider Enum
- `email` - Email/password authentication
- `google` - Google OAuth
- `github` - GitHub OAuth

---

## 2. UserPreferences Entity

**Purpose**: Stores user application settings and notification preferences.

| Attribute | Data Type | Required | Default | Description |
|-----------|-----------|----------|---------|-------------|
| pushNotificationsEnabled | Boolean | Yes | true | Enable push notifications |
| emailNotificationsEnabled | Boolean | Yes | true | Enable email notifications |
| groupUpdatesEnabled | Boolean | Yes | true | Notify about group activities |
| roadmapRemindersEnabled | Boolean | Yes | true | Send roadmap progress reminders |
| achievementNotificationsEnabled | Boolean | Yes | true | Notify when achievements unlocked |
| theme | String | Yes | 'system' | UI theme preference |
| language | String | Yes | 'en' | Preferred language code |

### Theme Values
- `light` - Light theme
- `dark` - Dark theme
- `system` - Follow system preference

---

## 3. Roadmap Entity

**Purpose**: Represents a complete learning pathway composed of multiple modules.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique roadmap identifier |
| title | String | Yes | Roadmap title |
| description | String | Yes | Detailed description |
| imageUrl | String | No | Header/banner image URL |
| iconUrl | String | No | Icon/thumbnail URL |
| category | Enum (RoadmapCategory) | Yes | Primary category |
| moduleIds | List<String> | Yes | Ordered list of module IDs |
| difficulty | Enum (RoadmapDifficulty) | Yes | Difficulty level |
| estimatedHours | Integer | Yes | Total estimated completion time |
| totalModules | Integer | Yes | Total number of modules |
| totalStages | Integer | Yes | Total number of stages across all modules |
| totalTasks | Integer | Yes | Total number of tasks |
| createdBy | String | Yes | Creator user ID |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |
| isPublished | Boolean | Yes | Is publicly available |
| enrolledCount | Integer | Yes | Number of enrolled users |
| averageRating | Double | Yes | Average user rating (0-5) |
| tags | List<String> | Yes | Additional searchable tags |

### RoadmapCategory Enum
- `technology` - Software/IT/Tech
- `business` - Business skills
- `design` - Design/UX/UI
- `marketing` - Marketing/Sales
- `dataScience` - Data/Analytics/ML
- `softSkills` - Communication/Leadership
- `language` - Human languages
- `other` - Other categories

### RoadmapDifficulty Enum
- `beginner` - Entry level
- `intermediate` - Some experience required
- `advanced` - Significant experience required
- `expert` - Expert level

---

## 4. Module Entity

**Purpose**: Reusable learning module that can be part of multiple roadmaps, containing stages.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique module identifier |
| title | String | Yes | Module title |
| description | String | Yes | Module description |
| imageUrl | String | No | Module thumbnail/icon URL |
| skillIds | List<String> | Yes | Skills taught in this module |
| stages | List<ModuleStage> | Yes | Ordered list of stages |
| difficulty | Enum (RoadmapDifficulty) | Yes | Module difficulty level |
| estimatedHours | Integer | Yes | Estimated completion time |
| totalStages | Integer | Yes | Number of stages in module |
| totalTasks | Integer | Yes | Total number of tasks |
| prerequisites | List<String> | Yes | Prerequisite module IDs |
| createdBy | String | Yes | Creator user ID |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |
| isPublished | Boolean | Yes | Is publicly available |
| usageCount | Integer | Yes | Number of roadmaps using this module |
| tags | List<String> | Yes | Searchable tags |

---

## 5. ModuleStage Entity

**Purpose**: Groups related learning items within a module into logical sections. Can contain tasks, quizzes (future), and resources (future).

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique stage identifier |
| moduleId | String | Yes | Parent module ID |
| title | String | Yes | Stage title |
| description | String | Yes | Stage description |
| order | Integer | Yes | Sequential order (0-indexed) |
| tasks | List<Task> | Yes | Learning tasks in this stage |
| quizzes | List<Quiz> | Yes | Quizzes (future scope - empty for now) |
| resources | List<StageResource> | Yes | Stage-level resources (future scope) |
| estimatedMinutes | Integer | Yes | Estimated completion time |
| isOptional | Boolean | Yes | Is this stage optional |

---

## 6. Task Entity

**Purpose**: Individual learning task or activity within a stage (formerly RoadmapStep).

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique task identifier |
| stageId | String | Yes | Parent stage ID |
| title | String | Yes | Task title |
| description | String | Yes | Detailed task description |
| order | Integer | Yes | Sequential order within stage |
| estimatedMinutes | Integer | Yes | Estimated completion time |
| resources | List<LearningResource> | Yes | Learning materials for this task |
| taskType | Enum (TaskType) | Yes | Type of task |
| isOptional | Boolean | Yes | Is this task optional |
| points | Integer | Yes | Points awarded for completion |

### TaskType Enum
- `reading` - Read content/documentation
- `watching` - Watch video content
- `practice` - Hands-on practice/exercise
- `project` - Build a project
- `research` - Research a topic
- `discussion` - Participate in discussion
- `other` - Other task types

---

## 7. Quiz Entity

**Purpose**: Assessment quiz within a stage (future scope - placeholder).

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique quiz identifier |
| stageId | String | Yes | Parent stage ID |
| title | String | Yes | Quiz title |
| description | String | Yes | Quiz description |
| order | Integer | Yes | Sequential order within stage |
| questions | List<QuizQuestion> | Yes | Quiz questions (future) |
| passingScore | Integer | Yes | Minimum score to pass (%) |
| timeLimit | Integer | No | Time limit in minutes |
| isOptional | Boolean | Yes | Is this quiz optional |
| points | Integer | Yes | Points awarded for completion |

*Note: This entity is included for future scope but will remain empty in initial implementation.*

---

## 8. StageResource Entity

**Purpose**: Stage-level resources that apply to the entire stage (future scope - placeholder).

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique resource identifier |
| stageId | String | Yes | Parent stage ID |
| title | String | Yes | Resource title |
| description | String | Yes | Resource description |
| url | String | Yes | Resource URL |
| type | Enum (ResourceType) | Yes | Type of resource |
| isRequired | Boolean | Yes | Is this resource required |

*Note: This entity is included for future scope but will remain empty in initial implementation.*

---

## 9. LearningResource Entity

**Purpose**: External learning material (article, video, course) linked to a step.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique resource identifier |
| title | String | Yes | Resource title |
| url | String | Yes | External URL |
| type | Enum (ResourceType) | Yes | Type of resource |
| description | String | No | Brief description |
| durationMinutes | Integer | No | Length of resource |
| isPaid | Boolean | Yes | Requires payment |
| thumbnailUrl | String | No | Preview image URL |

### ResourceType Enum
- `article` - Written article/blog post
- `video` - Video content
- `course` - Online course
- `book` - Book/eBook
- `documentation` - Technical documentation
- `tutorial` - Tutorial/guide
- `podcast` - Podcast episode
- `other` - Other types

---

## 7. Skill Entity

**Purpose**: Represents a specific competency or technology that can be learned.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique skill identifier |
| name | String | Yes | Skill name |
| description | String | Yes | Skill description |
| category | Enum (SkillCategory) | Yes | Skill category |
| relatedSkillIds | List<String> | Yes | Related/prerequisite skills |
| roadmapCount | Integer | Yes | Number of roadmaps teaching this |
| iconUrl | String | No | Skill icon URL |

### SkillCategory Enum
- `programming` - Programming languages
- `framework` - Frameworks/libraries
- `tool` - Development tools
- `softSkill` - Soft skills
- `design` - Design skills
- `business` - Business skills
- `language` - Human languages
- `other` - Other categories

---

## 11. UserRoadmapProgress Entity

**Purpose**: Tracks a user's progress through a specific roadmap.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique progress record ID |
| userId | String | Yes | User ID |
| roadmapId | String | Yes | Roadmap ID |
| startedAt | DateTime | Yes | When user started |
| completedAt | DateTime | No | When user completed (if applicable) |
| lastAccessedAt | DateTime | Yes | Last time user accessed |
| progressPercentage | Double | Yes | Overall completion percentage |
| completedTasks | Integer | Yes | Number of completed tasks |
| totalTasks | Integer | Yes | Total tasks in roadmap |
| moduleProgress | Map<String, ModuleProgress> | Yes | Module-level progress details |
| status | Enum (RoadmapStatus) | Yes | Current status |
| totalTimeSpentMinutes | Integer | Yes | Total time spent |
| currentModuleId | String | No | Currently active module ID |
| currentStageId | String | No | Currently active stage ID |

---

## 12. ModuleProgress Entity

**Purpose**: Tracks a user's progress through a specific module within a roadmap.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| moduleId | String | Yes | Module ID |
| startedAt | DateTime | No | When user started this module |
| completedAt | DateTime | No | When user completed this module |
| progressPercentage | Double | Yes | Module completion percentage |
| completedStages | Integer | Yes | Number of completed stages |
| totalStages | Integer | Yes | Total stages in module |
| completedTasks | Integer | Yes | Number of completed tasks |
| totalTasks | Integer | Yes | Total tasks in module |
| stageProgress | Map<String, StageProgress> | Yes | Stage-level progress details |
| status | Enum (ModuleStatus) | Yes | Current module status |

### ModuleStatus Enum
- `notStarted` - Not yet begun
- `inProgress` - Currently active
- `completed` - Finished
- `skipped` - User skipped this module

---

## 13. StageProgress Entity

**Purpose**: Tracks completion status for a specific stage within a module.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| stageId | String | Yes | Stage ID |
| startedAt | DateTime | No | When user started this stage |
| completedAt | DateTime | No | When user completed this stage |
| progressPercentage | Double | Yes | Stage completion percentage |
| completedTasks | Integer | Yes | Number of completed tasks |
| totalTasks | Integer | Yes | Total tasks in stage |
| taskProgress | Map<String, TaskProgress> | Yes | Task-level progress details |
| completedQuizzes | Integer | Yes | Number of completed quizzes (future) |
| totalQuizzes | Integer | Yes | Total quizzes in stage (future) |
| status | Enum (StageStatus) | Yes | Current stage status |

### StageStatus Enum
- `notStarted` - Not yet begun
- `inProgress` - Currently active
- `completed` - Finished
- `skipped` - User skipped this stage

---

## 14. TaskProgress Entity

**Purpose**: Tracks completion status and notes for a specific task (formerly StepProgress).

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| taskId | String | Yes | Task ID |
| isCompleted | Boolean | Yes | Is task completed |
| completedAt | DateTime | No | Completion timestamp |
| notes | String | No | User notes on task |
| completedResourceIds | List<String> | Yes | Resources user has consumed |
| timeSpentMinutes | Integer | Yes | Time spent on this task |

### RoadmapStatus Enum
- `notStarted` - Not yet begun
- `inProgress` - Currently active
- `completed` - Finished
- `paused` - Temporarily inactive

---

## 15. Group Entity

**Purpose**: Represents a peer learning group working on a shared roadmap.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique group identifier |
| name | String | Yes | Group name |
| description | String | Yes | Group description/purpose |
| roadmapId | String | Yes | Shared roadmap ID |
| createdBy | String | Yes | Creator user ID |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |
| members | List<GroupMember> | Yes | Group members |
| inviteCode | String | Yes | Unique invite code |
| maxMembers | Integer | Yes | Maximum member limit |
| isPrivate | Boolean | Yes | Is group invitation-only |
| averageProgress | Double | Yes | Average member progress % |

---

## 16. GroupMember Entity

**Purpose**: Represents a member within a group with their role and progress.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| userId | String | Yes | User ID |
| username | String | Yes | Username for display |
| profilePictureUrl | String | No | Profile picture URL |
| joinedAt | DateTime | Yes | When member joined |
| role | Enum (GroupRole) | Yes | Member's role |
| progressPercentage | Double | Yes | Member's progress % |

### GroupRole Enum
- `creator` - Group creator
- `admin` - Administrator
- `member` - Regular member

---

## 17. Activity Entity

**Purpose**: Represents an activity feed event for social features.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique activity identifier |
| userId | String | Yes | User who performed action |
| username | String | Yes | Username for display |
| userProfilePicture | String | No | User's profile picture |
| type | Enum (ActivityType) | Yes | Type of activity |
| targetId | String | Yes | ID of affected entity |
| targetName | String | Yes | Name of affected entity |
| timestamp | DateTime | Yes | When activity occurred |
| groupId | String | No | Associated group ID (if applicable) |
| metadata | Map<String, dynamic> | No | Additional activity data |

### ActivityType Enum
- `startedRoadmap` - User started a roadmap
- `completedTask` - User completed a task
- `completedModule` - User completed a module
- `completedRoadmap` - User completed a roadmap
- `joinedGroup` - User joined a group
- `earnedAchievement` - User earned an achievement
- `sharedProgress` - User shared their progress

---

## 18. Achievement Entity

**Purpose**: Represents a badge or milestone that can be earned.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| id | String | Yes | Unique achievement identifier |
| name | String | Yes | Achievement name |
| description | String | Yes | How to earn it |
| iconUrl | String | Yes | Badge icon URL |
| type | Enum (AchievementType) | Yes | Achievement category |
| points | Integer | Yes | Points awarded |
| unlockedAt | DateTime | No | When user unlocked (if applicable) |
| isUnlocked | Boolean | Yes | Is this unlocked for user |

### AchievementType Enum
- `firstTask` - First task completed
- `firstModule` - First module completed
- `firstRoadmap` - First roadmap completed
- `streak` - Daily/weekly streak
- `completion` - Completion milestone
- `social` - Social interaction
- `mastery` - Skill mastery

---

## 19. SuggestedRoadmap Entity

**Purpose**: Represents a personalized roadmap recommendation.

| Attribute | Data Type | Required | Description |
|-----------|-----------|----------|-------------|
| roadmapId | String | Yes | Recommended roadmap ID |
| relevanceScore | Double | Yes | Relevance score (0-1) |
| reasons | List<String> | Yes | Why this is recommended |

---

## Entity Relationships

### Primary Relationships
- **User** → **UserRoadmapProgress** (One-to-Many)
- **User** → **Group** (Many-to-Many via GroupMember)
- **Roadmap** → **Module** (Many-to-Many via moduleIds)
- **Module** → **ModuleStage** (One-to-Many)
- **ModuleStage** → **Task** (One-to-Many)
- **ModuleStage** → **Quiz** (One-to-Many) - *Future scope*
- **ModuleStage** → **StageResource** (One-to-Many) - *Future scope*
- **Task** → **LearningResource** (One-to-Many)
- **Module** → **Skill** (Many-to-Many via skillIds)
- **Group** → **Roadmap** (Many-to-One)
- **Group** → **GroupMember** (One-to-Many)
- **User** → **Activity** (One-to-Many)
- **User** → **Achievement** (Many-to-Many)
- **UserRoadmapProgress** → **ModuleProgress** (One-to-Many)
- **ModuleProgress** → **StageProgress** (One-to-Many)
- **StageProgress** → **TaskProgress** (One-to-Many)

### Key Hierarchical Structure
```
Roadmap
  └─ Module (reusable, can be in multiple roadmaps)
      ├─ Skills (associated at module level)
      └─ ModuleStage
          ├─ Task (current implementation)
          ├─ Quiz (future scope)
          └─ StageResource (future scope)
              └─ LearningResource (attached to tasks)
```

### Key Indexes Needed
- User: `email`, `username`
- Roadmap: `category`, `difficulty`, `isPublished`, `moduleIds`
- Module: `difficulty`, `isPublished`, `skillIds`
- ModuleStage: `moduleId`, `order`
- Task: `stageId`, `order`, `taskType`
- Skill: `name`, `category`
- UserRoadmapProgress: `userId`, `roadmapId`, `status`
- ModuleProgress: `moduleId`, `status`
- Group: `inviteCode`, `roadmapId`
- Activity: `userId`, `groupId`, `timestamp`

---

## Data Validation Rules

### User
- Email must be valid format
- Username: 3-30 characters, alphanumeric + underscore
- Password: minimum 8 characters (if email auth)

### Roadmap
- Title: 5-100 characters
- Description: 20-1000 characters
- estimatedHours: 1-1000
- totalModules: 1-50
- totalStages: 1-500
- totalTasks: 1-2000
- moduleIds must reference existing modules

### Module
- Title: 5-100 characters
- Description: 20-1000 characters
- estimatedHours: 1-200
- totalStages: 1-50
- totalTasks: 1-500
- skillIds must reference existing skills
- Must have at least one stage

### ModuleStage
- Title: 3-100 characters
- Description: 10-500 characters
- estimatedMinutes: 5-480 (8 hours max per stage)
- Must have at least one task (quizzes/resources optional for future)

### Task
- Title: 3-200 characters
- Description: 10-1000 characters
- estimatedMinutes: 5-480 (8 hours max per task)
- points: 0-1000

### Group
- Name: 3-50 characters
- Description: 10-500 characters
- maxMembers: 2-100
- inviteCode: 6-12 characters, unique

### Skill
- Name: 2-50 characters, unique
- Description: 10-300 characters

### Business Rules
- A module can be used in multiple roadmaps (reusability)
- Skills are associated at the module level, not individual tasks
- Stages within a module must have unique order values
- Tasks within a stage must have unique order values
- User cannot start a module without starting the roadmap
- Progress percentages calculated based on completed tasks
- Optional tasks/stages don't count toward required completion percentage