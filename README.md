# Task: To-Do List Application 

A simple task management application built with Flutter. It allows users to create, view, edit, complete, and delete tasks while keeping their data saved locally.

## Features

- **Add Tasks:** Create tasks with a title, category, date, time, and notes.
- **View Tasks:** View pending and completed tasks separately.
- **Edit Tasks:** Update the details of an existing task.
- **Complete Tasks:** Mark tasks as completed using the checkbox.
- **Delete Tasks:** Remove tasks with a confirmation prompt.
- **Local Storage:** Tasks are stored locally using Hive and remain available after restarting the application.

## How the Application Works

1. When the application starts, Hive initializes and opens the local `todos` storage box.
2. The Home Screen loads the saved tasks and displays them in two sections: Pending and Completed.
3. Users can tap **Add New Task** to open the task creation screen.
4. While creating a task, users can enter its title, select a category, choose a date and time, and add optional notes.
5. When the task is saved, its details are stored in Hive.
6. Users can tap an existing task to edit it or use the delete icon to remove it.
7. Selecting the checkbox updates the task's completion status and moves it to the appropriate section.
8. Changes are saved locally, so tasks remain available even after closing and reopening the app.

## Technologies Used

- **Flutter & Dart** – Application development
- **Hive** – Local data storage
- **Google Fonts** – Custom typography

## Getting Started

1. Clone the repository.
2. Open the project in your preferred IDE.
3. Install the dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

---

**Note:** This application uses local Hive storage and does not require an internet connection for its core functionality.
