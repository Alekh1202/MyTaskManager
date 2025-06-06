# MyTaskManager

_Author: Alekh Agrawal_  
_Date: June 6, 2025_

A simple cross-platform task manager app built with Flutter.  
Manage your daily tasks with an intuitive UI, persistent storage, and support for Android and iOS.

## Features

- Add, edit, and delete tasks
- Mark tasks as completed or pending
- Persistent local storage using Hive
- Clean, modern UI with Flutter Material Design
- State management with flutter_bloc

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- version 3.29.2

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/Alekh1202/MyTaskManager.git
   cd MyTaskManager
   ```

2. Install dependencies:
   ```sh
   flutter pub get
   ```

     ```

## Project Structure

- `lib/` - Main Dart source code
  - `main.dart` - App entry point
  - `models/` - Task model
  - `task_screen/` - UI, state management, and components
- `android/` - Android native code
- `ios/` - iOS native code
- `test/` - Widget tests

## Dependencies

- flutter_bloc
- hive
- path_provider

See `pubspec.yaml` for full details.

## Notable Concepts

### BlocBuilder `buildWhen` Optimization

This app uses the `buildWhen` property in `BlocBuilder` to optimize widget rebuilds. For example, in the task list, only the widgets for tasks that have changed (such as when a task is updated or deleted) are rebuilt, improving performance and responsiveness.

```dart
BlocBuilder<TaskCubit, TaskLoaded>(
  buildWhen: (previous, current) =>
    previous.tasks?.length != current.tasks?.length,
  builder: (context, state) {
    // ...
  },
)
```

- `buildWhen` is used to prevent unnecessary rebuilds of the entire task list when only a single task changes.
- This is especially useful for large lists, keeping the UI efficient.

#### Custom Logic Used in This App

In this app, the `buildWhen` logic is customized to rebuild only when:
- The number of tasks changes (a task is added or deleted)
- A specific task at a given index is updated (such as marking as done/undone or editing the title)

Example from the code:

```dart
BlocBuilder<TaskCubit, TaskLoaded>(
  buildWhen: (previous, current) =>
    current.lastUpdatedIndex == index ||
    previous.tasks?.length != current.tasks?.length,
  builder: (context, state) {
    // ...
  },
)
```

- `current.lastUpdatedIndex == index` ensures only the updated task card is rebuilt when a single task changes.
- `previous.tasks?.length != current.tasks?.length` ensures the list updates when tasks are added or removed.

This approach keeps the UI highly responsive and efficient, especially as your task list grows.


