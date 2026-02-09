
# Goal List App Blueprint

## Overview

This document outlines the plan for creating a goal list application for Flutter. The app will allow users to track their goals, including the date and time of creation and a timer for each goal. The user interface will be inspired by the "Things" iOS app by Cultured Code, focusing on a clean, minimalist design.

## Features

*   **Goal Management:** Users can add, view, and delete goals.
*   **Timestamping:** Each goal will automatically be stamped with the date and time of its creation.
*   **Goal Timers:** Each goal will have a timer to track the time spent on it.
*   **Minimalist UI:** The UI will be clean and uncluttered, with a focus on typography and whitespace, inspired by the "Things" app.

## Project Structure

```
.
├── lib
│   ├── main.dart
│   ├── models
│   │   └── goal.dart
│   ├── providers
│   │   └── goal_provider.dart
│   ├── screens
│   │   ├── add_goal_screen.dart
│   │   └── home_screen.dart
│   └── widgets
│       └── goal_list_item.dart
└── pubspec.yaml
```

## Implementation Plan

1.  **Add Dependencies:**
    *   `provider`: For state management.
    *   `google_fonts`: For custom typography.
    *   `go_router`: For navigation.

2.  **Create the `Goal` Model (`lib/models/goal.dart`):**
    *   A `Goal` class with properties for `title`, `creationDate`, and `duration`.

3.  **Create the `GoalProvider` (`lib/providers/goal_provider.dart`):**
    *   A `ChangeNotifier` to manage the list of goals.
    *   Methods to add, delete, and update goals.
    *   A `Timer` to update the duration of the active goal.

4.  **Create the UI:**
    *   **`HomeScreen` (`lib/screens/home_screen.dart`):**
        *   Display a list of goals using `ListView.builder`.
        *   A floating action button to navigate to the `AddGoalScreen`.
    *   **`GoalListItem` (`lib/widgets/goal_list_item.dart`):**
        *   A custom widget to display a single goal with its title, creation date, and timer.
    *   **`AddGoalScreen` (`lib/screens/add_goal_screen.dart`):**
        *   A form to add a new goal.

5.  **Update `main.dart`:**
    *   Set up `ChangeNotifierProvider` to provide the `GoalProvider` to the widget tree.
    *   Configure `go_router` for navigation between screens.
    *   Define a custom `ThemeData` to match the "Things" app aesthetic.
