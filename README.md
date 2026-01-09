# TaskFlow Mini

TaskFlow Mini is a Flutter-based task management application built as part of a technical assignment for **Delemon Technology**.  
The app demonstrates clean architecture, BLoC state management, role-based access, and local persistence using Hive.

---

## 🎯 Assignment Goal

Build a small task-management app with the hierarchy:

**Projects → Tasks → Subtasks**

The focus of this assignment is on:
- Flutter fundamentals
- Clean architecture
- State management using BLoC
- UI/UX handling (loading, empty, error states)

---

## 🚀 Features

### 🔐 Authentication (Demo)
- Static login using local Hive storage
- Two user roles:
    - **Admin**
    - **Employee**
- Session-based authentication with auto redirect

---

### 📁 Projects
- Create, edit, delete projects (**Admin only**)
- Assign projects to employees (**Admin only**)
- Archive / unarchive projects
- Employees see **only assigned projects**
- Assigned employee displayed in project listing

---

### 📝 Tasks
- Tasks belong to a project
- Fields:
    - Title, description
    - Status (todo, inProgress, blocked, inReview, done)
    - Priority (low, medium, high, critical)
    - Start date, due date
    - Estimate (hrs), time spent (hrs)
    - Labels (tags)
- Admin can assign/unassign employees
- Employees can update:
    - Task status
    - Time spent (only on assigned tasks)

---

### ☑️ Subtasks
- Checklist-style subtasks under a task
- Add new subtasks
- Mark as completed / uncompleted
- Optional assignee support

---

### 📊 Project Status Report
- Dashboard tiles:
    - Total tasks
    - Done
    - In Progress
    - Blocked
    - Overdue
    - Completion %
- Open tasks grouped by assignee

---

### 🎨 UI / UX
- Light & Dark theme support
- Primary color: **#0EA5E9**
- Responsive UI using `flutter_screenutil`
- Loading, empty, and error states handled

---

## 👥 Demo Login Credentials

### 👑 Admin

Email: admin@test.com

Password: 123456

### 👤 Employee
Email: staff1@test.com

Password: 123456

Email: staff2@test.com

Password: 123456


---

## 🧭 User Flow

### Admin Flow
1. Login as Admin
2. Create project
3. Assign project to employee
4. Add tasks & subtasks
5. Assign tasks to employees
6. View project reports
7. Archive or delete projects

### Employee Flow
1. Login as Employee
2. View assigned projects only
3. Update task status
4. Update time spent
5. Complete subtasks

---

## 🏗 Architecture Overview

The app follows **Clean Architecture** principles:


lib/
├── core/ # Theme, authentication, session
├── domain/ # Entities & repository contracts
├── data/ # Hive models & repository implementations
├── presentation/ # UI, BLoCs, pages
└── router/ # go_router configuration




### Architecture Highlights
- BLoC for state management (`flutter_bloc`)
- Repository pattern for data abstraction
- Domain layer independent of UI & storage
- Hive used for lightweight local persistence

---

## 🧰 Tech Stack

- Flutter (Stable, null-safe Dart)
- flutter_bloc + equatable
- go_router
- Hive (local database)
- flutter_screenutil

---

## ▶️ How to Run

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run

# TaskFlow-Mini-
# taskflow_mini
